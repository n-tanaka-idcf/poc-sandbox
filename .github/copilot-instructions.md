# Copilot Instructions for Production Infrastructure Repository

## 1. Repository Context (リポジトリの前提条件)
- **Purpose**: このリポジトリは本番環境（Production）およびそれに準ずる検証環境のインフラ構築コード（Infrastructure as Code）を管理するためのものです。
- **Environment**: 高可用性、スケーラビリティ、および耐障害性が求められる**本番環境**です。ダウンタイムやデータ喪失に繋がる破壊的な変更は原則として許容されません。
- **Tech Stack**: Terragrunt, Terraform, Ansible, Kubernetes (K8s) manifests.

## 2. Core Mindset (基本方針)
- **Reliability & Maintainability over Speed**: スピードよりも、システムの信頼性、セキュリティ、および長期的な保守性を最優先してコードを提案してください。
- **Proper Abstraction & DRY**: TerragruntおよびTerraformモジュールを活用し、DRY（Don't Repeat Yourself）原則に従って適切に抽象化・共通化を行ってください。ただし、過度な複雑化は避け、チーム全体でレビュー可能な可読性を担保してください。
- **Zero Tolerance for Tech Debt**: ハードコードや「とりあえず」の仮設定は厳禁です。すべての値は変数化し、外部から注入可能な設計にしてください。
- **Comment Driven & Contextual**: 複雑なロジックや、標準的ではない回避策（Workaround）を実装する場合は、必ず「なぜそのアプローチをとったのか」という背景と意図をコメントで明確に残してください。

## 3. Technology Specific Guidelines (技術別のガイドライン)

### Terragrunt & Terraform
- 常に**非破壊的（Non-Destructive）**な変更を前提とし、ステートフルなリソース（DB、ストレージなど）には必ず `lifecycle { prevent_destroy = true }` を付与する提案を含めてください。
- リソースの命名規則は組織の規約に従い、一貫性を保ってください。
- ファイル分割（`main.tf`, `variables.tf`, `outputs.tf`）を徹底し、入力・出力のインターフェースを型指定（`type`）やバリデーション（`validation`ブロック）を用いて厳格に定義してください。
- IAMやセキュリティグループの設定を提案する際は、常に**「最小権限の原則（Principle of Least Privilege）」**に従ってください。

### Ansible
- タスクには必ず明確な `name` を記述し、実行時のログで何が行われているか追跡できるようにしてください。
- 厳密な冪等性（何度実行しても同じ結果になり、変更がない場合は `changed=false` となること）を担保するモジュール選択・記述を行ってください。
- エラーハンドリング（`failed_when`など）を適切に行い、予期せぬ状態でのサイレントな進行を防いでください。

### Kubernetes Manifests
- 可用性を担保するため、Deployment等では複数レプリカ（`replicas > 1`）、PodAntiAffinity、およびPodDisruptionBudget (PDB) の設定を基本として提案してください。
- リソース割り当て（`resources: requests` / `limits`）は、本番の負荷を想定した具体的な値（または変数のプレースホルダー）を必ず設定し、OOMKilledやCPUスロットリングを防ぐ設計にしてください。
- ヘルスチェック（`livenessProbe`, `readinessProbe`）を必ず実装してください。

## 4. Security & Safety (セキュリティと安全性)
- パスワード、APIトークン、秘密鍵などのクレデンシャル情報を**絶対に平文で記述しないでください**。
- シークレット管理ツール（AWS Secrets Manager, HashiCorp Vault, Kubernetes External Secretsなど）から動的に値を取得、あるいはCI/CDパイプラインから安全に注入される設計を提案してください。
- パブリックアクセス（例: `0.0.0.0/0`）を伴うネットワーク設定を提案する場合は、それが真に意図されたものであるか警告を含めてください。
