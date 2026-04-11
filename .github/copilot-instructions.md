# Copilot Instructions for Infrastructure POC Repository

## 1. Repository Context (リポジトリの前提条件)
- **Purpose**: このリポジトリはPOC（概念実証）用のインフラ構築コード（Infrastructure as Code）を管理するためのものです。
- **Environment**: 本番環境（Production）ではありません。実験的であり、スクラップ＆ビルドが頻繁に行われます。
- **Tech Stack**: Terraform, Ansible, Kubernetes (K8s) manifests を扱います。

## 2. Core Mindset (基本方針)
- **Speed & Simplicity over Perfection**: 過度な抽象化（複雑なTerraformモジュールやAnsibleロールの分割）は避け、可読性と構築スピードを優先してください。
- **Explicit > Implicit**: DRY（Don't Repeat Yourself）よりも、一つのファイルを見ただけで構成が理解できる「ベタ書き」を許容します。
- **Comment Driven**: なぜその設定値にしたのか、意図がわかるコメントを記述してください。
- **Tech Debt Allowed**: ハードコードや仮の設定値を記述する場合は、必ず `TODO: [理由]` または `FIXME: [理由]` のコメントを残してください。

## 3. Technology Specific Guidelines (技術別のガイドライン)

### Terraform
- リソースの命名規則はシンプルで直感的なものにしてください（例: `poc_web_server`）。
- 必須ではありませんが、可能であれば `variables.tf` よりも `locals` を使って同一ファイル内で変数を完結させると、POC段階では見やすくなります。
- 破壊的な変更（`destroy`）が発生しやすい構成であることを前提にコードを提案してください。

### Ansible
- 各タスク（`name:`）には、何をしているのかが明確にわかる具体的な説明を記述してください。
- 冪等性（何度実行しても同じ結果になること）を常に意識したモジュール選択を行ってください。
- 複雑な `shell` や `command` モジュールの使用は避け、極力Ansibleの標準モジュールを使用してください。

### Kubernetes Manifests
- APIバージョンは、非推奨になったものを避け、広く使われている安定版（`v1`, `apps/v1`など）を使用してください。
- 複雑なHelmチャートの作成は避け、素のYAML（Raw Manifests）またはシンプルなKustomizeでの提案を優先してください。
- Podの `resources` (requests/limits) は、POC用として小さめの仮の値を必ず設定してください。

## 4. Security & Safety (セキュリティと安全性)
- パスワード、シークレットキー、APIトークンなどのクレデンシャル情報を**絶対にハードコードしないでください**。
- 代わりに、環境変数（例: `var.db_password`）やプレースホルダー（例: `<YOUR_SECRET_HERE>`）を使用するよう提案してください。
