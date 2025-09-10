function proxy_on
    set -Ux http_proxy "socks5h://localhost:1080"
    set -Ux https_proxy "socks5h://localhost:1080"
    set -Ux all_proxy "socks5h://localhost:1080"
end

function proxy_off
    set -Ue http_proxy
    set -Ue https_proxy
    set -Ue all_proxy

    set -U http_proxy
    set -U https_proxy
    set -U all_proxy
end

function proxy
    proxy_on

    # 执行传入的命令
    command $argv

    proxy_off
end
