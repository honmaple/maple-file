package types

type UploadPolicy string

const (
	UploadPolicyPreserve UploadPolicy = "preserve"
	UploadPolicyRename   UploadPolicy = "rename"
)

type FileSetting struct {
	UploadPolicy UploadPolicy `json:"upload.policy"`
	Thumb        ThumbSetting `json:"thumb"`
}

type ThumbSetting struct {
	Width     int  `json:"width"`
	Height    int  `json:"height"`
	Quality   int  `json:"quality"`
	AutoClean bool `json:"auto_clean"`
}
