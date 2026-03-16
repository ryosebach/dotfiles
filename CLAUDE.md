# CLAUDE.md

## Language

- Respond in Japanese unless explicitly asked otherwise.

# Bash コマンド発行ルール

以下のパターンは毎回パーミッション確認が発生するため、**絶対に使用しないこと**:

### 1. クォート文字を含むコマンド

`echo "---"` のようなクォート付き文字列を含む Bash コマンドは「Command contains quoted characters in flag names」エラーが発生する。テキスト出力には Bash ではなく直接テキストを返すこと。

**禁止例:**

```bash
git log --oneline cfa3a54 -1 && echo "---" && git show cfa3a54 --stat
```

**代替:** 複数の Bash ツール呼び出しに分割するか、Read/Grep 等の専用ツールを使用する。

### 2. `cd` と `git` の同一コマンド内での併用

`cd` と `git` を一つのコマンドとして発行すると毎回パーミッション確認が発生する。必ず別々のコマンドとして実行すること。これは Subagent（Explore 含む）でも同様。

**禁止例:**

```bash
cd /path/to/repo && git status
```

**代替:** 別々の Bash 呼び出しに分割する。どうしても実行できない場合は `git -C /path/to/repo status` を使用する。

### 3. `$()` コマンド置換を含むコマンド

`$()` を含む Bash コマンドは「Command contains $() command substitution」エラーが発生する。

**禁止例:**

```bash
for dir in /path/to/*/; do echo "=== $(basename "$dir") ==="; ls -1 "$dir"; done
```

**代替:** Glob/Read/Grep 等の専用ツールを使用するか、`$()` を使わない形にコマンドを分割する。

### 4. クォート内改行 + `#` 行を含むコマンド

クォート内の改行後に `#` で始まる行があると「Command contains a quoted newline followed by a #-prefixed line」エラーが発生する。特に `git commit -m` の HEREDOC で発生しやすい。

**禁止例:**

```bash
git commit -m "$(cat <<'EOF'
Fix bug

# Co-Authored-By: ...
EOF
)"
```

**代替:** Write ツールで一時ファイル（例: `/tmp/commit_msg.txt`）にメッセージを書き出し、`git commit -F /tmp/commit_msg.txt` を使用する。コミット後は `rm /tmp/commit_msg.txt` で削除する。
