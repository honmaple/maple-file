package types

type UploadPolicy string

const (
	UploadPolicyPreserve UploadPolicy = "preserve"
	UploadPolicyRename   UploadPolicy = "rename"
)

type FileSetting struct {
	UploadPolicy UploadPolicy `json:"upload.policy"`
}
