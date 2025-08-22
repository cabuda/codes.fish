function gitauto
    # 自动提交所有修改，如果有用户输入消息则使用该消息，否则使用时间戳

    # 添加所有修改
    git add -A

    # 检查是否有用户输入的提交消息
    if test (count $argv) -gt 0
        set commit_message $argv[1]
    else
        set commit_message "Auto commit: (date '+%Y-%m-%d %H:%M:%S')"
    end

    # 提交更改
    git commit -m "$commit_message"

    echo "Committed all changes with message: '$commit_message'"
end
