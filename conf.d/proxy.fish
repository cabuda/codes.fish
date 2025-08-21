function proxy_ssh_on
    # 设置代理（修改成你的代理地址）
    set -Ux http_proxy "socks5h://localhost:1080"
    set -Ux https_proxy "socks5h://localhost:1080"
    set -Ux all_proxy "socks5h://localhost:1080"
end

function proxy_ssh_off
    # 执行完后取消代理
    set -Ue http_proxy
    set -Ue https_proxy
    set -Ue all_proxy
end

function proxy_ssh
    proxy_ssh_on

    # 执行传入的命令
    command $argv

    proxy_ssh_off
end
