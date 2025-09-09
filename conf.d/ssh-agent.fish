function start_ssh_agent --description 'Start ssh-agent and add keys if not running'
    # 若 SSH_AGENT_PID 为空或进程不存在，则启动新 agent
    if not set -q SSH_AGENT_PID; or not ps -p $SSH_AGENT_PID > /dev/null 2>&1
        eval (ssh-agent -c)        # 写环境变量
        ssh-add -q                 # 将默认 key 加入 agent（可改路径或多次 ssh-add）
        echo "🔑 ssh-agent started."
    end
end

if test (uname) = "Darwin"
    start_ssh_agent
end
