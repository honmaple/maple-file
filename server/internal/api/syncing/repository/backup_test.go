package repository

import (
	"context"
	"path/filepath"
	"testing"
	"time"

	"github.com/honmaple/maple-file/server/internal/api/syncing/types"
	"github.com/honmaple/maple-file/server/internal/app"
	"github.com/honmaple/maple-file/server/internal/platform/database"
	pb "github.com/honmaple/maple-file/server/internal/proto/api/syncing"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func TestBackupRecordsAndHistory(t *testing.T) {
	ctx := context.Background()
	db, err := database.New(&database.Config{DSN: "sqlite://" + filepath.Join(t.TempDir(), "backup.db")})
	if err != nil {
		t.Fatal(err)
	}
	if err := db.AutoMigrate(new(pb.SyncProfile), new(pb.SyncRecord), new(pb.SyncHistory), new(pb.SyncHistoryIssue)); err != nil {
		t.Fatal(err)
	}
	repo := New(&types.Context{Context: &app.Context{DB: db}})
	profile, err := repo.CreateProfile(ctx, &pb.SyncProfile{Name: "相册", SourceType: "album", SourceConfig: `{"album_ids":["a"]}`, Enabled: true, Mode: pb.SyncProfile_MODE_BACKUP, TargetType: "repo_directory", TargetConfig: `{"path":"/photos","layout":"year_month_day"}`})
	if err != nil {
		t.Fatal(err)
	}
	if profile.PolicyConfig != "{}" {
		t.Fatalf("default policy config = %q", profile.PolicyConfig)
	}
	if db.Migrator().HasTable("sync_policies") {
		t.Fatal("unexpected separate policy table")
	}
	if db.Migrator().HasTable("sync_sources") {
		t.Fatal("unexpected separate source table")
	}
	if profile.ConfigVersion != 1 {
		t.Fatalf("initial config version = %d", profile.ConfigVersion)
	}
	profile.Name = "相册 2"
	profile, err = repo.UpdateProfile(ctx, profile)
	if err != nil || profile.ConfigVersion != 1 {
		t.Fatalf("renaming changed config version: %v %v", profile, err)
	}
	profile.PolicyConfig = `{"delete":"propagate"}`
	if _, err := repo.UpdateProfile(ctx, profile); err == nil {
		t.Fatal("unsupported album policy was accepted")
	}
	profile.PolicyConfig = "{}"
	profile.TargetConfig = `{"path":"/photos","layout":"flat"}`
	profile, err = repo.UpdateProfile(ctx, profile)
	if err != nil || profile.ConfigVersion != 2 {
		t.Fatalf("mapping change did not bump version: %v %v", profile, err)
	}
	profile.SourceConfig = `{"album_ids":["a","a"]}`
	if _, err := repo.UpdateProfile(ctx, profile); err == nil {
		t.Fatal("duplicate source was accepted")
	}
	profile.SourceConfig = `{"album_ids":["a"]}`
	modified := timestamppb.New(time.Date(2026, 9, 18, 10, 0, 0, 0, time.UTC))
	sourceSize, targetSize := int64(10), int64(10)
	record := &pb.SyncRecord{ProfileId: profile.Id, SourcePath: "a", SourceKey: "photo-1", TargetPath: "/photos/old.jpg", ConfigVersion: profile.ConfigVersion, SourceSize: &sourceSize, TargetSize: &targetSize, SourceModifiedAt: modified, SourceHashAlgorithm: "sha256", SourceHash: "abc", State: pb.SyncRecord_STATE_ACTIVE}
	if err := repo.UpsertRecords(ctx, []*pb.SyncRecord{record}); err != nil {
		t.Fatal(err)
	}
	record.TargetPath = "/photos/new.jpg"
	targetSize = 20
	record.Id = 0
	if err := repo.UpsertRecords(ctx, []*pb.SyncRecord{record}); err != nil {
		t.Fatal(err)
	}
	records, err := repo.ListRecords(ctx, profile.Id, "a", []string{"photo-1"})
	if err != nil || len(records) != 1 || records[0].TargetPath != "/photos/new.jpg" || records[0].GetTargetSize() != 20 || records[0].GetSourceSize() != 10 || records[0].GetSourceHash() != "abc" || !records[0].GetSourceModifiedAt().AsTime().Equal(modified.AsTime()) {
		t.Fatalf("record was not updated: records=%v err=%v", records, err)
	}
	profile.SourceConfig = `{"album_ids":["a","b"]}`
	profile, err = repo.UpdateProfile(ctx, profile)
	if err != nil || profile.ConfigVersion != 2 {
		t.Fatalf("adding source changed mapping version: %v %v", profile, err)
	}
	otherRecord := proto.Clone(record).(*pb.SyncRecord)
	otherRecord.Id = 0
	otherRecord.SourcePath = "b"
	if err := repo.UpsertRecords(ctx, []*pb.SyncRecord{otherRecord}); err != nil {
		t.Fatal(err)
	}
	records, err = repo.ListRecords(ctx, profile.Id, "b", []string{"photo-1"})
	if err != nil || len(records) != 1 {
		t.Fatalf("same item in second album was lost: %v %v", records, err)
	}
	history, err := repo.StartHistory(ctx, &pb.SyncHistory{ProfileId: profile.Id, RunId: "run-1", StartedAt: modified, Trigger: pb.SyncHistory_TRIGGER_MANUAL})
	if err != nil || history.Id == 0 {
		t.Fatalf("start history: history=%v err=%v", history, err)
	}
	_, err = repo.FinishHistory(ctx, &pb.SyncHistory{ProfileId: profile.Id, RunId: "run-1", Status: pb.SyncHistory_STATUS_PARTIAL, FinishedAt: timestamppb.New(modified.AsTime().Add(time.Minute)), Synced: 1, Failed: 1, Issues: []*pb.SyncHistoryIssue{{SourcePath: "a", SourceKey: "photo-1", SourceLabel: "a.jpg", ErrorMessage: "上传失败", Kind: pb.SyncHistoryIssue_KIND_ERROR}}})
	if err != nil {
		t.Fatal(err)
	}
	histories, err := repo.ListHistories(ctx, profile.Id, 0, 20)
	if err != nil || len(histories) != 1 || len(histories[0].Issues) != 1 || histories[0].Issues[0].ErrorMessage != "上传失败" {
		t.Fatalf("history was not loaded with failures: histories=%v err=%v", histories, err)
	}
	issues, err := repo.ListHistoryIssues(ctx, &pb.SyncHistoryIssue_ListRequest{HistoryId: history.Id, Kind: pb.SyncHistoryIssue_KIND_ERROR, SourceKey: "photo-1"})
	if err != nil || len(issues) != 1 {
		t.Fatalf("issue query failed: %v %v", issues, err)
	}
	if _, err := repo.StartHistory(ctx, &pb.SyncHistory{ProfileId: profile.Id, RunId: "run-2", StartedAt: modified, Trigger: pb.SyncHistory_TRIGGER_MANUAL}); err != nil {
		t.Fatal(err)
	}
	if err := repo.InterruptHistories(ctx); err != nil {
		t.Fatal(err)
	}
	histories, err = repo.ListHistories(ctx, profile.Id, 0, 1)
	if err != nil || len(histories) != 1 || histories[0].Status != pb.SyncHistory_STATUS_INTERRUPTED {
		t.Fatalf("interrupted history: %v %v", histories, err)
	}
	older, err := repo.ListHistories(ctx, profile.Id, histories[0].Id, 1)
	if err != nil || len(older) != 1 || older[0].RunId != "run-1" {
		t.Fatalf("history cursor: %v %v", older, err)
	}
	profile.SourceConfig = `{"album_ids":["b"]}`
	profile, err = repo.UpdateProfile(ctx, profile)
	if err != nil || profile.ConfigVersion != 2 {
		t.Fatalf("source selection changed config version: %v %v", profile, err)
	}
	records, err = repo.ListRecords(ctx, profile.Id, "a", []string{"photo-1"})
	if err != nil || len(records) != 0 {
		t.Fatalf("removed source retained records: %v %v", records, err)
	}
	records, err = repo.ListRecords(ctx, profile.Id, "b", []string{"photo-1"})
	if err != nil || len(records) != 1 {
		t.Fatalf("other source record was removed: %v %v", records, err)
	}
	if err := repo.DeleteProfile(ctx, profile.Id); err != nil {
		t.Fatal(err)
	}
	var issueCount int64
	if err := db.Model(&pb.SyncHistoryIssue{}).Count(&issueCount).Error; err != nil || issueCount != 0 {
		t.Fatalf("history issues remained after profile deletion: count=%d err=%v", issueCount, err)
	}
}
