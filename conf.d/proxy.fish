function proxy_on
    set -gx http_proxy "http://localhost:10800"
    set -gx https_proxy "http://localhost:10800"
    set -gx all_proxy "http://localhost:10800"
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
