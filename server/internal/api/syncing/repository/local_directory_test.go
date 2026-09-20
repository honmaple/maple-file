package repository

import (
	"context"
	"encoding/json"
	"path/filepath"
	"testing"

	"github.com/honmaple/maple-file/server/internal/api/syncing/types"
	"github.com/honmaple/maple-file/server/internal/app"
	"github.com/honmaple/maple-file/server/internal/platform/database"
	pb "github.com/honmaple/maple-file/server/internal/proto/api/syncing"
)

func localSourceJSON(path, bookmark string) string {
	value, _ := json.Marshal(map[string]string{"path": path, "bookmark": bookmark})
	return string(value)
}

func TestLocalDirectoryProfileAndRecords(t *testing.T) {
	ctx := context.Background()
	db, err := database.New(&database.Config{DSN: "sqlite://" + filepath.Join(t.TempDir(), "sync.db")})
	if err != nil {
		t.Fatal(err)
	}
	if err := db.AutoMigrate(new(pb.SyncProfile), new(pb.SyncRecord), new(pb.SyncHistory), new(pb.SyncHistoryIssue)); err != nil {
		t.Fatal(err)
	}
	repo := New(&types.Context{Context: &app.Context{DB: db}})
	root := filepath.Join(t.TempDir(), "source")
	profile, err := repo.CreateProfile(ctx, &pb.SyncProfile{
		Name:         "local",
		Enabled:      true,
		Mode:         pb.SyncProfile_MODE_ONE_WAY,
		SourceType:   "local_directory",
		SourceConfig: localSourceJSON(root, "a"),
		TargetType:   "repo_directory",
		TargetConfig: `{"path":"/cloud/backup"}`,
		PolicyConfig: `{}`,
	})
	if err != nil {
		t.Fatal(err)
	}
	parent := filepath.Join(root, "nested")
	if err := ValidateSourceEntry(profile, parent, "file.txt"); err != nil {
		t.Fatalf("valid source entry rejected: %v", err)
	}
	if err := ValidateSourceEntry(profile, filepath.Dir(root), "file.txt"); err == nil {
		t.Fatal("source path outside root was accepted")
	}
	if err := ValidateSourceEntry(profile, parent, "../file.txt"); err == nil {
		t.Fatal("invalid source key was accepted")
	}
	record := &pb.SyncRecord{
		ProfileId:     profile.Id,
		SourcePath:    parent,
		SourceKey:     "file.txt",
		TargetPath:    "/cloud/backup/nested/file.txt",
		ConfigVersion: profile.ConfigVersion,
		State:         pb.SyncRecord_STATE_ACTIVE,
	}
	if err := repo.UpsertRecords(ctx, []*pb.SyncRecord{record}); err != nil {
		t.Fatal(err)
	}
	profile.SourceConfig = localSourceJSON(root, "b")
	profile, err = repo.UpdateProfile(ctx, profile)
	if err != nil {
		t.Fatal(err)
	}
	results, err := repo.ListRecords(ctx, profile.Id, parent, []string{"file.txt"})
	if err != nil || len(results) != 1 {
		t.Fatalf("bookmark update removed records: %v %v", results, err)
	}
	profile.TargetConfig = `{"path":"/cloud/new"}`
	profile, err = repo.UpdateProfile(ctx, profile)
	if err != nil || profile.ConfigVersion != 2 {
		t.Fatalf("target update did not bump version: %v %v", profile, err)
	}
	newRoot := filepath.Join(t.TempDir(), "other")
	profile.SourceConfig = localSourceJSON(newRoot, "c")
	profile, err = repo.UpdateProfile(ctx, profile)
	if err != nil {
		t.Fatal(err)
	}
	results, err = repo.ListRecords(ctx, profile.Id, parent, []string{"file.txt"})
	if err != nil || len(results) != 0 {
		t.Fatalf("source root update retained records: %v %v", results, err)
	}
}

func TestLocalDirectoryProfileValidation(t *testing.T) {
	base := &pb.SyncProfile{
		Name:         "local",
		Mode:         pb.SyncProfile_MODE_ONE_WAY,
		SourceType:   "local_directory",
		SourceConfig: `{"path":"/tmp/source"}`,
		TargetType:   "repo_directory",
		TargetConfig: `{"path":"/cloud/backup"}`,
		PolicyConfig: `{}`,
	}
	if err := verifyProfile(base); err != nil {
		t.Fatal(err)
	}
	invalidMode := *base
	invalidMode.Mode = pb.SyncProfile_MODE_TWO_WAY
	if err := verifyProfile(&invalidMode); err == nil {
		t.Fatal("two-way local directory profile was accepted")
	}
	invalidPolicy := *base
	invalidPolicy.PolicyConfig = `{"delete":true}`
	if err := verifyProfile(&invalidPolicy); err == nil {
		t.Fatal("unsupported local directory policy was accepted")
	}
}

func TestAlbumSourceEntryValidationRemainsSupported(t *testing.T) {
	profile := &pb.SyncProfile{
		Name:         "album",
		Mode:         pb.SyncProfile_MODE_BACKUP,
		SourceType:   "album",
		SourceConfig: `{"album_ids":["album-1"]}`,
		TargetType:   "repo_directory",
		TargetConfig: `{"path":"/cloud/backup","layout":"year_month_day"}`,
		PolicyConfig: `{}`,
	}
	if err := verifyProfile(profile); err != nil {
		t.Fatal(err)
	}
	if err := ValidateSourceEntry(profile, "album-1", "asset-1"); err != nil {
		t.Fatalf("valid album source entry rejected: %v", err)
	}
	if err := ValidateSourceEntry(profile, "album-2", "asset-1"); err == nil {
		t.Fatal("unconfigured album source was accepted")
	}
}
