function proxy_on
    set -gx http_proxy "socks5h://localhost:1080"
    set -gx https_proxy "socks5h://localhost:1080"
    set -gx all_proxy "socks5h://localhost:1080"
end

function proxy_off
    set -e http_proxy
    set -e https_proxy
    set -e all_proxy
end

function proxy
    proxy_on

    # 执行传入的命令
    command $argv

    proxy_off
end
