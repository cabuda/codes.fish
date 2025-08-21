function proxy_ssh
    # 设置代理（修改成你的代理地址）
    set -x http_proxy "socks5h://localhost:1080"
    set -x https_proxy "socks5h://localhost:1080"
    set -x all_proxy "socks5h://localhost:1080"

    # 执行传入的命令
    command $argv

    # 执行完后取消代理
    set -e http_proxy
    set -e https_proxy
    set -e all_proxy
end
