# Cài /z-ask và /z-commit trên laptop

## Cài (Windows)

```powershell
Expand-Archive .\cursor-z-ask-20260929.zip -DestinationPath .
$pack = Get-ChildItem .\cursor-z-ask-20260929 -Directory | Select-Object -First 1
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.cursor\skills" | Out-Null
Copy-Item "$($pack.FullName)\skills\*" "$env:USERPROFILE\.cursor\skills\" -Recurse -Force
```

Mở Agent chat mới. `/z-ask` chỉ đánh giá, không sửa code. `/z-commit` chỉ commit file của chức năng được ghi kèm, hoặc file vừa trao đổi nếu không ghi gì.
