#!/bin/bash

TARGET_DIR="./conflict-test"

rm -rf "$TARGET_DIR"
mkdir "$TARGET_DIR"
cd "$TARGET_DIR" || exit

git init -b main > /dev/null 2>&1

cat > conflicted.lua << 'EOF'
local a = "initial"
-- line 2
-- line 3
-- line 4
-- line 5
-- line 6
-- line 7
-- line 8
-- line 9
-- line 10
-- line 11
local b = "initial"
-- line 13
-- line 14
-- line 15
-- line 16
-- line 17
-- line 18
-- line 19
-- line 20
-- line 21
-- line 22
local c = "initial"
EOF

git add conflicted.lua > /dev/null 2>&1
git commit -m 'initial' > /dev/null 2>&1

git checkout -b new_branch > /dev/null 2>&1
sed -i '1s/.*/local a = "branch_update"/' conflicted.lua
sed -i '12s/.*/local b = "branch_update"/' conflicted.lua
sed -i '23s/.*/local c = "branch_update"/' conflicted.lua
git commit -am 'update on new_branch' > /dev/null 2>&1

git checkout main > /dev/null 2>&1
sed -i '1s/.*/local a = "main_update"/' conflicted.lua
sed -i '12s/.*/local b = "main_update"/' conflicted.lua
sed -i '23s/.*/local c = "main_update"/' conflicted.lua
git commit -am 'update on main' > /dev/null 2>&1

git merge new_branch > /dev/null 2>&1

echo "Conflicted file created in $TARGET_DIR/conflicted.lua"
