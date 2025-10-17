function start_ssh_agent --description 'Start ssh-agent and add keys if not running'
    set -l agent_file ~/.ssh/agent_env

    # 如果文件存在，则加载环境变量
    if test -f $agent_file
        source $agent_file >/dev/null
    end

    # 检查 agent 是否仍在运行
    if not set -q SSH_AGENT_PID; or not ps -p $SSH_AGENT_PID >/dev/null 2>&1
        echo "Starting new ssh-agent..."
        ssh-agent -c | sed 's/^setenv/set -x/' >$agent_file
        source $agent_file >/dev/null
        ssh-add -q
    end
end

if test (uname) = "Darwin"
    start_ssh_agent
end
