#!/bin/bash
sh_v="4.4.0"


gl_hui='\e[37m'
gl_hong='\033[31m'
gl_lv='\033[32m'
gl_huang='\033[33m'
gl_lan='\033[34m'
gl_bai='\033[0m'
gl_zi='\033[35m'
gl_kjlan='\033[96m'


canshu="default"
permission_granted="true"
ENABLE_STATS="true"


quanju_canshu() {
if [ "$canshu" = "CN" ]; then
	zhushi=0
	gh_proxy="https://gh.kejilion.pro/"
elif [ "$canshu" = "V6" ]; then
	zhushi=1
	gh_proxy="https://gh.kejilion.pro/"
else
	zhushi=1  # 0 琛ㄧず鎵ц锛? 琛ㄧず涓嶆墽琛?
	gh_proxy="https://"
fi

gh_https_url="https://"

}
quanju_canshu



# 瀹氫箟涓€涓嚱鏁版潵鎵ц鍛戒护
run_command() {
	if [ "$zhushi" -eq 0 ]; then
		"$@"
	fi
}


canshu_v6() {
	if grep -q '^canshu="V6"' /usr/local/bin/k > /dev/null 2>&1; then
		sed -i 's/^canshu="default"/canshu="V6"/' ~/kejilion.sh
	fi
}


CheckFirstRun_true() {
	if grep -q '^permission_granted="true"' /usr/local/bin/k > /dev/null 2>&1; then
		sed -i 's/^permission_granted="false"/permission_granted="true"/' ~/kejilion.sh
	fi
}



# 鏀堕泦鍔熻兘鍩嬬偣淇℃伅鐨勫嚱鏁帮紝璁板綍褰撳墠鑴氭湰鐗堟湰鍙凤紝浣跨敤鏃堕棿锛岀郴缁熺増鏈紝CPU鏋舵瀯锛屾満鍣ㄦ墍鍦ㄥ浗瀹跺拰鐢ㄦ埛浣跨敤鐨勫姛鑳藉悕绉帮紝缁濆涓嶆秹鍙婁换浣曟晱鎰熶俊鎭紝璇锋斁蹇冿紒璇风浉淇℃垜锛?
# 涓轰粈涔堣璁捐杩欎釜鍔熻兘锛岀洰鐨勬洿濂界殑浜嗚В鐢ㄦ埛鍠滄浣跨敤鐨勫姛鑳斤紝杩涗竴姝ヤ紭鍖栧姛鑳芥帹鍑烘洿澶氱鍚堢敤鎴烽渶姹傜殑鍔熻兘銆?
# 鍏ㄦ枃鍙悳鎼?send_stats 鍑芥暟璋冪敤浣嶇疆锛岄€忔槑寮€婧愶紝濡傛湁椤捐檻鍙嫆缁濅娇鐢ㄣ€?



send_stats() {
	if [ "$ENABLE_STATS" == "false" ]; then
		return
	fi

	local country=$(curl -s ipinfo.io/country)
	local os_info=$(grep PRETTY_NAME /etc/os-release | cut -d '=' -f2 | tr -d '"')
	local cpu_arch=$(uname -m)

	(
		curl -s -X POST "https://api.kejilion.pro/api/log" \
			-H "Content-Type: application/json" \
			-d "{\"action\":\"$1\",\"timestamp\":\"$(date -u '+%Y-%m-%d %H:%M:%S')\",\"country\":\"$country\",\"os_info\":\"$os_info\",\"cpu_arch\":\"$cpu_arch\",\"version\":\"$sh_v\"}" \
		&>/dev/null
	) &

}


yinsiyuanquan2() {

if grep -q '^ENABLE_STATS="false"' /usr/local/bin/k > /dev/null 2>&1; then
	sed -i 's/^ENABLE_STATS="true"/ENABLE_STATS="false"/' ~/kejilion.sh
fi

}



canshu_v6
CheckFirstRun_true
yinsiyuanquan2


sed -i '/^alias k=/d' ~/.bashrc > /dev/null 2>&1
sed -i '/^alias k=/d' ~/.profile > /dev/null 2>&1
sed -i '/^alias k=/d' ~/.bash_profile > /dev/null 2>&1
cp -f ./kejilion.sh ~/kejilion.sh > /dev/null 2>&1
cp -f ~/kejilion.sh /usr/local/bin/k > /dev/null 2>&1
ln -sf /usr/local/bin/k /usr/bin/k > /dev/null 2>&1



CheckFirstRun_false() {
	if grep -q '^permission_granted="false"' /usr/local/bin/k > /dev/null 2>&1; then
		UserLicenseAgreement
	fi
}

# 鎻愮ず鐢ㄦ埛鍚屾剰鏉℃
UserLicenseAgreement() {
	clear
	echo -e "${gl_kjlan}娆㈣繋浣跨敤绉戞妧lion鑴氭湰宸ュ叿绠?{gl_bai}"
	echo "棣栨浣跨敤鑴氭湰锛岃鍏堥槄璇诲苟鍚屾剰鐢ㄦ埛璁稿彲鍗忚銆?
	echo "鐢ㄦ埛璁稿彲鍗忚: https://blog.kejilion.pro/user-license-agreement/"
	echo -e "----------------------"
	read -e -p "鏄惁鍚屾剰浠ヤ笂鏉℃锛?y/n): " user_input


	if [ "$user_input" = "y" ] || [ "$user_input" = "Y" ]; then
		send_stats "璁稿彲鍚屾剰"
		sed -i 's/^permission_granted="false"/permission_granted="true"/' ~/kejilion.sh
		sed -i 's/^permission_granted="false"/permission_granted="true"/' /usr/local/bin/k
	else
		send_stats "璁稿彲鎷掔粷"
		clear
		exit
	fi
}

CheckFirstRun_false





ip_address() {

get_public_ip() {
	curl -s https://ipinfo.io/ip && echo
}

get_local_ip() {
	ip route get 8.8.8.8 2>/dev/null | grep -oP 'src \K[^ ]+' || \
	hostname -I 2>/dev/null | awk '{print $1}' || \
	ifconfig 2>/dev/null | grep -E 'inet [0-9]' | grep -v '127.0.0.1' | awk '{print $2}' | head -n1
}

public_ip=$(get_public_ip)
isp_info=$(curl -s --max-time 3 http://ipinfo.io/org)


if echo "$isp_info" | grep -Eiq 'CHINANET|mobile|unicom|telecom'; then
  ipv4_address=$(get_local_ip)
else
  ipv4_address="$public_ip"
fi


# ipv4_address=$(curl -s https://ipinfo.io/ip && echo)
ipv6_address=$(curl -s --max-time 1 https://v6.ipinfo.io/ip && echo)

}



install() {
	if [ $# -eq 0 ]; then
		echo "鏈彁渚涜蒋浠跺寘鍙傛暟!"
		return 1
	fi

	for package in "$@"; do
		if ! command -v "$package" &>/dev/null; then
			echo -e "${gl_kjlan}姝ｅ湪瀹夎 $package...${gl_bai}"
			if command -v dnf &>/dev/null; then
				dnf -y update
				dnf install -y epel-release
				dnf install -y "$package"
			elif command -v yum &>/dev/null; then
				yum -y update
				yum install -y epel-release
				yum install -y "$package"
			elif command -v apt &>/dev/null; then
				apt update -y
				apt install -y "$package"
			elif command -v apk &>/dev/null; then
				apk update
				apk add "$package"
			elif command -v pacman &>/dev/null; then
				pacman -Syu --noconfirm
				pacman -S --noconfirm "$package"
			elif command -v zypper &>/dev/null; then
				zypper refresh
				zypper install -y "$package"
			elif command -v opkg &>/dev/null; then
				opkg update
				opkg install "$package"
			elif command -v pkg &>/dev/null; then
				pkg update
				pkg install -y "$package"
			else
				echo "鏈煡鐨勫寘绠＄悊鍣?"
				return 1
			fi
		fi
	done
}


check_disk_space() {
	local required_gb=$1
	local path=${2:-/}

	mkdir -p "$path"

	local required_space_mb=$((required_gb * 1024))
	local available_space_mb=$(df -m "$path" | awk 'NR==2 {print $4}')

	if [ "$available_space_mb" -lt "$required_space_mb" ]; then
		echo -e "${gl_huang}鎻愮ず: ${gl_bai}纾佺洏绌洪棿涓嶈冻锛?
		echo "褰撳墠鍙敤绌洪棿: $((available_space_mb/1024))G"
		echo "鏈€灏忛渶姹傜┖闂? ${required_gb}G"
		echo "鏃犳硶缁х画瀹夎锛岃娓呯悊纾佺洏绌洪棿鍚庨噸璇曘€?
		send_stats "纾佺洏绌洪棿涓嶈冻"
		break_end
		kejilion
	fi
}



install_dependency() {
	switch_mirror false false
	check_port
	check_swap
	prefer_ipv4
	auto_optimize_dns
	install wget unzip tar jq grep

}

remove() {
	if [ $# -eq 0 ]; then
		echo "鏈彁渚涜蒋浠跺寘鍙傛暟!"
		return 1
	fi

	for package in "$@"; do
		echo -e "${gl_kjlan}姝ｅ湪鍗歌浇 $package...${gl_bai}"
		if command -v dnf &>/dev/null; then
			dnf remove -y "$package"
		elif command -v yum &>/dev/null; then
			yum remove -y "$package"
		elif command -v apt &>/dev/null; then
			apt purge -y "$package"
		elif command -v apk &>/dev/null; then
			apk del "$package"
		elif command -v pacman &>/dev/null; then
			pacman -Rns --noconfirm "$package"
		elif command -v zypper &>/dev/null; then
			zypper remove -y "$package"
		elif command -v opkg &>/dev/null; then
			opkg remove "$package"
		elif command -v pkg &>/dev/null; then
			pkg delete -y "$package"
		else
			echo "鏈煡鐨勫寘绠＄悊鍣?"
			return 1
		fi
	done
}


# 閫氱敤 systemctl 鍑芥暟锛岄€傜敤浜庡悇绉嶅彂琛岀増
systemctl() {
	local COMMAND="$1"
	local SERVICE_NAME="$2"

	if command -v apk &>/dev/null; then
		service "$SERVICE_NAME" "$COMMAND"
	else
		/bin/systemctl "$COMMAND" "$SERVICE_NAME"
	fi
}


# 閲嶅惎鏈嶅姟
restart() {
	systemctl restart "$1"
	if [ $? -eq 0 ]; then
		echo "$1 鏈嶅姟宸查噸鍚€?
	else
		echo "閿欒锛氶噸鍚?$1 鏈嶅姟澶辫触銆?
	fi
}

# 鍚姩鏈嶅姟
start() {
	systemctl start "$1"
	if [ $? -eq 0 ]; then
		echo "$1 鏈嶅姟宸插惎鍔ㄣ€?
	else
		echo "閿欒锛氬惎鍔?$1 鏈嶅姟澶辫触銆?
	fi
}

# 鍋滄鏈嶅姟
stop() {
	systemctl stop "$1"
	if [ $? -eq 0 ]; then
		echo "$1 鏈嶅姟宸插仠姝€?
	else
		echo "閿欒锛氬仠姝?$1 鏈嶅姟澶辫触銆?
	fi
}

# 鏌ョ湅鏈嶅姟鐘舵€?
status() {
	systemctl status "$1"
	if [ $? -eq 0 ]; then
		echo "$1 鏈嶅姟鐘舵€佸凡鏄剧ず銆?
	else
		echo "閿欒锛氭棤娉曟樉绀?$1 鏈嶅姟鐘舵€併€?
	fi
}


enable() {
	local SERVICE_NAME="$1"
	if command -v apk &>/dev/null; then
		rc-update add "$SERVICE_NAME" default
	else
	   /bin/systemctl enable "$SERVICE_NAME"
	fi

	echo "$SERVICE_NAME 宸茶缃负寮€鏈鸿嚜鍚€?
}



break_end() {
	  echo -e "${gl_lv}鎿嶄綔瀹屾垚${gl_bai}"
	  echo "鎸変换鎰忛敭缁х画..."
	  read -n 1 -s -r -p ""
	  echo ""
	  clear
}

kejilion() {
			cd ~
			kejilion_sh
}




stop_containers_or_kill_process() {
	local port=$1
	local containers=$(docker ps --filter "publish=$port" --format "{{.ID}}" 2>/dev/null)

	if [ -n "$containers" ]; then
		docker stop $containers
	else
		install lsof
		for pid in $(lsof -t -i:$port); do
			kill -9 $pid
		done
	fi
}


check_port() {
	stop_containers_or_kill_process 80
	stop_containers_or_kill_process 443
}


install_add_docker_cn() {

local country=$(curl -s ipinfo.io/country)
if [ "$country" = "CN" ]; then
	cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors": [
	"https://docker.1ms.run",
	"https://docker.m.ixdev.cn",
	"https://hub.rat.dev",
	"https://dockerproxy.net",
	"https://docker-registry.nmqu.com",
	"https://docker.amingg.com",
	"https://docker.hlmirror.com",
	"https://hub1.nat.tf",
	"https://hub2.nat.tf",
	"https://hub3.nat.tf",
	"https://docker.m.daocloud.io",
	"https://docker.kejilion.pro",
	"https://docker.367231.xyz",
	"https://hub.1panel.dev",
	"https://dockerproxy.cool",
	"https://docker.apiba.cn",
	"https://proxy.vvvv.ee"
  ]
}
EOF
fi


enable docker
start docker
restart docker

}



linuxmirrors_install_docker() {

local country=$(curl -s ipinfo.io/country)
if [ "$country" = "CN" ]; then
	bash <(curl -sSL https://linuxmirrors.cn/docker.sh) \
	  --source mirrors.huaweicloud.com/docker-ce \
	  --source-registry docker.1ms.run \
	  --protocol https \
	  --use-intranet-source false \
	  --install-latest true \
	  --close-firewall false \
	  --ignore-backup-tips
else
	bash <(curl -sSL https://linuxmirrors.cn/docker.sh) \
	  --source download.docker.com \
	  --source-registry registry.hub.docker.com \
	  --protocol https \
	  --use-intranet-source false \
	  --install-latest true \
	  --close-firewall false \
	  --ignore-backup-tips
fi

install_add_docker_cn

}



install_add_docker() {
	echo -e "${gl_kjlan}姝ｅ湪瀹夎docker鐜...${gl_bai}"
	if command -v apt &>/dev/null || command -v yum &>/dev/null || command -v dnf &>/dev/null; then
		linuxmirrors_install_docker
	else
		install docker docker-compose
		install_add_docker_cn

	fi
	sleep 2
}


install_docker() {
	if ! command -v docker &>/dev/null; then
		install_add_docker
	fi
}


docker_ps() {
while true; do
	clear
	send_stats "Docker瀹瑰櫒绠＄悊"
	echo "Docker瀹瑰櫒鍒楄〃"
	docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
	echo ""
	echo "瀹瑰櫒鎿嶄綔"
	echo "------------------------"
	echo "1. 鍒涘缓鏂扮殑瀹瑰櫒"
	echo "------------------------"
	echo "2. 鍚姩鎸囧畾瀹瑰櫒             6. 鍚姩鎵€鏈夊鍣?
	echo "3. 鍋滄鎸囧畾瀹瑰櫒             7. 鍋滄鎵€鏈夊鍣?
	echo "4. 鍒犻櫎鎸囧畾瀹瑰櫒             8. 鍒犻櫎鎵€鏈夊鍣?
	echo "5. 閲嶅惎鎸囧畾瀹瑰櫒             9. 閲嶅惎鎵€鏈夊鍣?
	echo "------------------------"
	echo "11. 杩涘叆鎸囧畾瀹瑰櫒           12. 鏌ョ湅瀹瑰櫒鏃ュ織"
	echo "13. 鏌ョ湅瀹瑰櫒缃戠粶           14. 鏌ョ湅瀹瑰櫒鍗犵敤"
	echo "------------------------"
	echo "15. 寮€鍚鍣ㄧ鍙ｈ闂?      16. 鍏抽棴瀹瑰櫒绔彛璁块棶"
	echo "------------------------"
	echo "0. 杩斿洖涓婁竴绾ч€夊崟"
	echo "------------------------"
	read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice
	case $sub_choice in
		1)
			send_stats "鏂板缓瀹瑰櫒"
			read -e -p "璇疯緭鍏ュ垱寤哄懡浠? " dockername
			$dockername
			;;
		2)
			send_stats "鍚姩鎸囧畾瀹瑰櫒"
			read -e -p "璇疯緭鍏ュ鍣ㄥ悕锛堝涓鍣ㄥ悕璇风敤绌烘牸鍒嗛殧锛? " dockername
			docker start $dockername
			;;
		3)
			send_stats "鍋滄鎸囧畾瀹瑰櫒"
			read -e -p "璇疯緭鍏ュ鍣ㄥ悕锛堝涓鍣ㄥ悕璇风敤绌烘牸鍒嗛殧锛? " dockername
			docker stop $dockername
			;;
		4)
			send_stats "鍒犻櫎鎸囧畾瀹瑰櫒"
			read -e -p "璇疯緭鍏ュ鍣ㄥ悕锛堝涓鍣ㄥ悕璇风敤绌烘牸鍒嗛殧锛? " dockername
			docker rm -f $dockername
			;;
		5)
			send_stats "閲嶅惎鎸囧畾瀹瑰櫒"
			read -e -p "璇疯緭鍏ュ鍣ㄥ悕锛堝涓鍣ㄥ悕璇风敤绌烘牸鍒嗛殧锛? " dockername
			docker restart $dockername
			;;
		6)
			send_stats "鍚姩鎵€鏈夊鍣?
			docker start $(docker ps -a -q)
			;;
		7)
			send_stats "鍋滄鎵€鏈夊鍣?
			docker stop $(docker ps -q)
			;;
		8)
			send_stats "鍒犻櫎鎵€鏈夊鍣?
			read -e -p "$(echo -e "${gl_hong}娉ㄦ剰: ${gl_bai}纭畾鍒犻櫎鎵€鏈夊鍣ㄥ悧锛?Y/N): ")" choice
			case "$choice" in
			  [Yy])
				docker rm -f $(docker ps -a -q)
				;;
			  [Nn])
				;;
			  *)
				echo "鏃犳晥鐨勯€夋嫨锛岃杈撳叆 Y 鎴?N銆?
				;;
			esac
			;;
		9)
			send_stats "閲嶅惎鎵€鏈夊鍣?
			docker restart $(docker ps -q)
			;;
		11)
			send_stats "杩涘叆瀹瑰櫒"
			read -e -p "璇疯緭鍏ュ鍣ㄥ悕: " dockername
			docker exec -it $dockername /bin/sh
			break_end
			;;
		12)
			send_stats "鏌ョ湅瀹瑰櫒鏃ュ織"
			read -e -p "璇疯緭鍏ュ鍣ㄥ悕: " dockername
			docker logs $dockername
			break_end
			;;
		13)
			send_stats "鏌ョ湅瀹瑰櫒缃戠粶"
			echo ""
			container_ids=$(docker ps -q)
			echo "------------------------------------------------------------"
			printf "%-25s %-25s %-25s\n" "瀹瑰櫒鍚嶇О" "缃戠粶鍚嶇О" "IP鍦板潃"
			for container_id in $container_ids; do
				local container_info=$(docker inspect --format '{{ .Name }}{{ range $network, $config := .NetworkSettings.Networks }} {{ $network }} {{ $config.IPAddress }}{{ end }}' "$container_id")
				local container_name=$(echo "$container_info" | awk '{print $1}')
				local network_info=$(echo "$container_info" | cut -d' ' -f2-)
				while IFS= read -r line; do
					local network_name=$(echo "$line" | awk '{print $1}')
					local ip_address=$(echo "$line" | awk '{print $2}')
					printf "%-20s %-20s %-15s\n" "$container_name" "$network_name" "$ip_address"
				done <<< "$network_info"
			done
			break_end
			;;
		14)
			send_stats "鏌ョ湅瀹瑰櫒鍗犵敤"
			docker stats --no-stream
			break_end
			;;

		15)
			send_stats "鍏佽瀹瑰櫒绔彛璁块棶"
			read -e -p "璇疯緭鍏ュ鍣ㄥ悕: " docker_name
			ip_address
			clear_container_rules "$docker_name" "$ipv4_address"
			local docker_port=$(docker port $docker_name | awk -F'[:]' '/->/ {print $NF}' | uniq)
			check_docker_app_ip
			break_end
			;;

		16)
			send_stats "闃绘瀹瑰櫒绔彛璁块棶"
			read -e -p "璇疯緭鍏ュ鍣ㄥ悕: " docker_name
			ip_address
			block_container_port "$docker_name" "$ipv4_address"
			local docker_port=$(docker port $docker_name | awk -F'[:]' '/->/ {print $NF}' | uniq)
			check_docker_app_ip
			break_end
			;;

		*)
			break  # 璺冲嚭寰幆锛岄€€鍑鸿彍鍗?
			;;
	esac
done
}


docker_image() {
while true; do
	clear
	send_stats "Docker闀滃儚绠＄悊"
	echo "Docker闀滃儚鍒楄〃"
	docker image ls
	echo ""
	echo "闀滃儚鎿嶄綔"
	echo "------------------------"
	echo "1. 鑾峰彇鎸囧畾闀滃儚             3. 鍒犻櫎鎸囧畾闀滃儚"
	echo "2. 鏇存柊鎸囧畾闀滃儚             4. 鍒犻櫎鎵€鏈夐暅鍍?
	echo "------------------------"
	echo "0. 杩斿洖涓婁竴绾ч€夊崟"
	echo "------------------------"
	read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice
	case $sub_choice in
		1)
			send_stats "鎷夊彇闀滃儚"
			read -e -p "璇疯緭鍏ラ暅鍍忓悕锛堝涓暅鍍忓悕璇风敤绌烘牸鍒嗛殧锛? " imagenames
			for name in $imagenames; do
				echo -e "${gl_kjlan}姝ｅ湪鑾峰彇闀滃儚: $name${gl_bai}"
				docker pull $name
			done
			;;
		2)
			send_stats "鏇存柊闀滃儚"
			read -e -p "璇疯緭鍏ラ暅鍍忓悕锛堝涓暅鍍忓悕璇风敤绌烘牸鍒嗛殧锛? " imagenames
			for name in $imagenames; do
				echo -e "${gl_kjlan}姝ｅ湪鏇存柊闀滃儚: $name${gl_bai}"
				docker pull $name
			done
			;;
		3)
			send_stats "鍒犻櫎闀滃儚"
			read -e -p "璇疯緭鍏ラ暅鍍忓悕锛堝涓暅鍍忓悕璇风敤绌烘牸鍒嗛殧锛? " imagenames
			for name in $imagenames; do
				docker rmi -f $name
			done
			;;
		4)
			send_stats "鍒犻櫎鎵€鏈夐暅鍍?
			read -e -p "$(echo -e "${gl_hong}娉ㄦ剰: ${gl_bai}纭畾鍒犻櫎鎵€鏈夐暅鍍忓悧锛?Y/N): ")" choice
			case "$choice" in
			  [Yy])
				docker rmi -f $(docker images -q)
				;;
			  [Nn])
				;;
			  *)
				echo "鏃犳晥鐨勯€夋嫨锛岃杈撳叆 Y 鎴?N銆?
				;;
			esac
			;;
		*)
			break  # 璺冲嚭寰幆锛岄€€鍑鸿彍鍗?
			;;
	esac
done


}





check_crontab_installed() {
	if ! command -v crontab >/dev/null 2>&1; then
		install_crontab
	fi
}



install_crontab() {

	if [ -f /etc/os-release ]; then
		. /etc/os-release
		case "$ID" in
			ubuntu|debian|kali)
				apt update
				apt install -y cron
				systemctl enable cron
				systemctl start cron
				;;
			centos|rhel|almalinux|rocky|fedora)
				yum install -y cronie
				systemctl enable crond
				systemctl start crond
				;;
			alpine)
				apk add --no-cache cronie
				rc-update add crond
				rc-service crond start
				;;
			arch|manjaro)
				pacman -S --noconfirm cronie
				systemctl enable cronie
				systemctl start cronie
				;;
			opensuse|suse|opensuse-tumbleweed)
				zypper install -y cron
				systemctl enable cron
				systemctl start cron
				;;
			iStoreOS|openwrt|ImmortalWrt|lede)
				opkg update
				opkg install cron
				/etc/init.d/cron enable
				/etc/init.d/cron start
				;;
			FreeBSD)
				pkg install -y cronie
				sysrc cron_enable="YES"
				service cron start
				;;
			*)
				echo "涓嶆敮鎸佺殑鍙戣鐗? $ID"
				return
				;;
		esac
	else
		echo "鏃犳硶纭畾鎿嶄綔绯荤粺銆?
		return
	fi

	echo -e "${gl_lv}crontab 宸插畨瑁呬笖 cron 鏈嶅姟姝ｅ湪杩愯銆?{gl_bai}"
}



docker_ipv6_on() {
	root_use
	install jq

	local CONFIG_FILE="/etc/docker/daemon.json"
	local REQUIRED_IPV6_CONFIG='{"ipv6": true, "fixed-cidr-v6": "2001:db8:1::/64"}'

	# 妫€鏌ラ厤缃枃浠舵槸鍚﹀瓨鍦紝濡傛灉涓嶅瓨鍦ㄥ垯鍒涘缓鏂囦欢骞跺啓鍏ラ粯璁よ缃?
	if [ ! -f "$CONFIG_FILE" ]; then
		echo "$REQUIRED_IPV6_CONFIG" | jq . > "$CONFIG_FILE"
		restart docker
	else
		# 浣跨敤jq澶勭悊閰嶇疆鏂囦欢鐨勬洿鏂?
		local ORIGINAL_CONFIG=$(<"$CONFIG_FILE")

		# 妫€鏌ュ綋鍓嶉厤缃槸鍚﹀凡缁忔湁 ipv6 璁剧疆
		local CURRENT_IPV6=$(echo "$ORIGINAL_CONFIG" | jq '.ipv6 // false')

		# 鏇存柊閰嶇疆锛屽紑鍚?IPv6
		if [[ "$CURRENT_IPV6" == "false" ]]; then
			UPDATED_CONFIG=$(echo "$ORIGINAL_CONFIG" | jq '. + {ipv6: true, "fixed-cidr-v6": "2001:db8:1::/64"}')
		else
			UPDATED_CONFIG=$(echo "$ORIGINAL_CONFIG" | jq '. + {"fixed-cidr-v6": "2001:db8:1::/64"}')
		fi

		# 瀵规瘮鍘熷閰嶇疆涓庢柊閰嶇疆
		if [[ "$ORIGINAL_CONFIG" == "$UPDATED_CONFIG" ]]; then
			echo -e "${gl_huang}褰撳墠宸插紑鍚痠pv6璁块棶${gl_bai}"
		else
			echo "$UPDATED_CONFIG" | jq . > "$CONFIG_FILE"
			restart docker
		fi
	fi
}


docker_ipv6_off() {
	root_use
	install jq

	local CONFIG_FILE="/etc/docker/daemon.json"

	# 妫€鏌ラ厤缃枃浠舵槸鍚﹀瓨鍦?
	if [ ! -f "$CONFIG_FILE" ]; then
		echo -e "${gl_hong}閰嶇疆鏂囦欢涓嶅瓨鍦?{gl_bai}"
		return
	fi

	# 璇诲彇褰撳墠閰嶇疆
	local ORIGINAL_CONFIG=$(<"$CONFIG_FILE")

	# 浣跨敤jq澶勭悊閰嶇疆鏂囦欢鐨勬洿鏂?
	local UPDATED_CONFIG=$(echo "$ORIGINAL_CONFIG" | jq 'del(.["fixed-cidr-v6"]) | .ipv6 = false')

	# 妫€鏌ュ綋鍓嶇殑 ipv6 鐘舵€?
	local CURRENT_IPV6=$(echo "$ORIGINAL_CONFIG" | jq -r '.ipv6 // false')

	# 瀵规瘮鍘熷閰嶇疆涓庢柊閰嶇疆
	if [[ "$CURRENT_IPV6" == "false" ]]; then
		echo -e "${gl_huang}褰撳墠宸插叧闂璱pv6璁块棶${gl_bai}"
	else
		echo "$UPDATED_CONFIG" | jq . > "$CONFIG_FILE"
		restart docker
		echo -e "${gl_huang}宸叉垚鍔熷叧闂璱pv6璁块棶${gl_bai}"
	fi
}



save_iptables_rules() {
	mkdir -p /etc/iptables
	touch /etc/iptables/rules.v4
	iptables-save > /etc/iptables/rules.v4
	check_crontab_installed
	crontab -l | grep -v 'iptables-restore' | crontab - > /dev/null 2>&1
	(crontab -l ; echo '@reboot iptables-restore < /etc/iptables/rules.v4') | crontab - > /dev/null 2>&1

}




iptables_open() {
	install iptables
	save_iptables_rules
	iptables -P INPUT ACCEPT
	iptables -P FORWARD ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables -F

	ip6tables -P INPUT ACCEPT
	ip6tables -P FORWARD ACCEPT
	ip6tables -P OUTPUT ACCEPT
	ip6tables -F

}



open_port() {
	local ports=($@)  # 灏嗕紶鍏ョ殑鍙傛暟杞崲涓烘暟缁?
	if [ ${#ports[@]} -eq 0 ]; then
		echo "璇锋彁渚涜嚦灏戜竴涓鍙ｅ彿"
		return 1
	fi

	install iptables

	for port in "${ports[@]}"; do
		# 鍒犻櫎宸插瓨鍦ㄧ殑鍏抽棴瑙勫垯
		iptables -D INPUT -p tcp --dport $port -j DROP 2>/dev/null
		iptables -D INPUT -p udp --dport $port -j DROP 2>/dev/null

		# 娣诲姞鎵撳紑瑙勫垯
		if ! iptables -C INPUT -p tcp --dport $port -j ACCEPT 2>/dev/null; then
			iptables -I INPUT 1 -p tcp --dport $port -j ACCEPT
		fi

		if ! iptables -C INPUT -p udp --dport $port -j ACCEPT 2>/dev/null; then
			iptables -I INPUT 1 -p udp --dport $port -j ACCEPT
			echo "宸叉墦寮€绔彛 $port"
		fi
	done

	save_iptables_rules
	send_stats "宸叉墦寮€绔彛"
}


close_port() {
	local ports=($@)  # 灏嗕紶鍏ョ殑鍙傛暟杞崲涓烘暟缁?
	if [ ${#ports[@]} -eq 0 ]; then
		echo "璇锋彁渚涜嚦灏戜竴涓鍙ｅ彿"
		return 1
	fi

	install iptables

	for port in "${ports[@]}"; do
		# 鍒犻櫎宸插瓨鍦ㄧ殑鎵撳紑瑙勫垯
		iptables -D INPUT -p tcp --dport $port -j ACCEPT 2>/dev/null
		iptables -D INPUT -p udp --dport $port -j ACCEPT 2>/dev/null

		# 娣诲姞鍏抽棴瑙勫垯
		if ! iptables -C INPUT -p tcp --dport $port -j DROP 2>/dev/null; then
			iptables -I INPUT 1 -p tcp --dport $port -j DROP
		fi

		if ! iptables -C INPUT -p udp --dport $port -j DROP 2>/dev/null; then
			iptables -I INPUT 1 -p udp --dport $port -j DROP
			echo "宸插叧闂鍙?$port"
		fi
	done

	# 鍒犻櫎宸插瓨鍦ㄧ殑瑙勫垯锛堝鏋滄湁锛?
	iptables -D INPUT -i lo -j ACCEPT 2>/dev/null
	iptables -D FORWARD -i lo -j ACCEPT 2>/dev/null

	# 鎻掑叆鏂拌鍒欏埌绗竴鏉?
	iptables -I INPUT 1 -i lo -j ACCEPT
	iptables -I FORWARD 1 -i lo -j ACCEPT

	save_iptables_rules
	send_stats "宸插叧闂鍙?
}


allow_ip() {
	local ips=($@)  # 灏嗕紶鍏ョ殑鍙傛暟杞崲涓烘暟缁?
	if [ ${#ips[@]} -eq 0 ]; then
		echo "璇锋彁渚涜嚦灏戜竴涓狪P鍦板潃鎴朓P娈?
		return 1
	fi

	install iptables

	for ip in "${ips[@]}"; do
		# 鍒犻櫎宸插瓨鍦ㄧ殑闃绘瑙勫垯
		iptables -D INPUT -s $ip -j DROP 2>/dev/null

		# 娣诲姞鍏佽瑙勫垯
		if ! iptables -C INPUT -s $ip -j ACCEPT 2>/dev/null; then
			iptables -I INPUT 1 -s $ip -j ACCEPT
			echo "宸叉斁琛孖P $ip"
		fi
	done

	save_iptables_rules
	send_stats "宸叉斁琛孖P"
}

block_ip() {
	local ips=($@)  # 灏嗕紶鍏ョ殑鍙傛暟杞崲涓烘暟缁?
	if [ ${#ips[@]} -eq 0 ]; then
		echo "璇锋彁渚涜嚦灏戜竴涓狪P鍦板潃鎴朓P娈?
		return 1
	fi

	install iptables

	for ip in "${ips[@]}"; do
		# 鍒犻櫎宸插瓨鍦ㄧ殑鍏佽瑙勫垯
		iptables -D INPUT -s $ip -j ACCEPT 2>/dev/null

		# 娣诲姞闃绘瑙勫垯
		if ! iptables -C INPUT -s $ip -j DROP 2>/dev/null; then
			iptables -I INPUT 1 -s $ip -j DROP
			echo "宸查樆姝P $ip"
		fi
	done

	save_iptables_rules
	send_stats "宸查樆姝P"
}







enable_ddos_defense() {
	# 寮€鍚槻寰?DDoS
	iptables -A DOCKER-USER -p tcp --syn -m limit --limit 500/s --limit-burst 100 -j ACCEPT
	iptables -A DOCKER-USER -p tcp --syn -j DROP
	iptables -A DOCKER-USER -p udp -m limit --limit 3000/s -j ACCEPT
	iptables -A DOCKER-USER -p udp -j DROP
	iptables -A INPUT -p tcp --syn -m limit --limit 500/s --limit-burst 100 -j ACCEPT
	iptables -A INPUT -p tcp --syn -j DROP
	iptables -A INPUT -p udp -m limit --limit 3000/s -j ACCEPT
	iptables -A INPUT -p udp -j DROP

	send_stats "寮€鍚疍DoS闃插尽"
}

# 鍏抽棴DDoS闃插尽
disable_ddos_defense() {
	# 鍏抽棴闃插尽 DDoS
	iptables -D DOCKER-USER -p tcp --syn -m limit --limit 500/s --limit-burst 100 -j ACCEPT 2>/dev/null
	iptables -D DOCKER-USER -p tcp --syn -j DROP 2>/dev/null
	iptables -D DOCKER-USER -p udp -m limit --limit 3000/s -j ACCEPT 2>/dev/null
	iptables -D DOCKER-USER -p udp -j DROP 2>/dev/null
	iptables -D INPUT -p tcp --syn -m limit --limit 500/s --limit-burst 100 -j ACCEPT 2>/dev/null
	iptables -D INPUT -p tcp --syn -j DROP 2>/dev/null
	iptables -D INPUT -p udp -m limit --limit 3000/s -j ACCEPT 2>/dev/null
	iptables -D INPUT -p udp -j DROP 2>/dev/null

	send_stats "鍏抽棴DDoS闃插尽"
}





# 绠＄悊鍥藉IP瑙勫垯鐨勫嚱鏁?
manage_country_rules() {
	local action="$1"
	shift  # 鍘绘帀绗竴涓弬鏁帮紝鍓╀笅鐨勫叏鏄浗瀹朵唬鐮?

	install ipset

	for country_code in "$@"; do
		local ipset_name="${country_code,,}_block"
		local download_url="http://www.ipdeny.com/ipblocks/data/countries/${country_code,,}.zone"

		case "$action" in
			block)
				if ! ipset list "$ipset_name" &> /dev/null; then
					ipset create "$ipset_name" hash:net
				fi

				if ! wget -q "$download_url" -O "${country_code,,}.zone"; then
					echo "閿欒锛氫笅杞?$country_code 鐨?IP 鍖哄煙鏂囦欢澶辫触"
					continue
				fi

				while IFS= read -r ip; do
					ipset add "$ipset_name" "$ip" 2>/dev/null
				done < "${country_code,,}.zone"

				iptables -I INPUT -m set --match-set "$ipset_name" src -j DROP

				echo "宸叉垚鍔熼樆姝?$country_code 鐨?IP 鍦板潃"
				rm "${country_code,,}.zone"
				;;

			allow)
				if ! ipset list "$ipset_name" &> /dev/null; then
					ipset create "$ipset_name" hash:net
				fi

				if ! wget -q "$download_url" -O "${country_code,,}.zone"; then
					echo "閿欒锛氫笅杞?$country_code 鐨?IP 鍖哄煙鏂囦欢澶辫触"
					continue
				fi

				ipset flush "$ipset_name"
				while IFS= read -r ip; do
					ipset add "$ipset_name" "$ip" 2>/dev/null
				done < "${country_code,,}.zone"


				iptables -P INPUT DROP
				iptables -A INPUT -m set --match-set "$ipset_name" src -j ACCEPT

				echo "宸叉垚鍔熷厑璁?$country_code 鐨?IP 鍦板潃"
				rm "${country_code,,}.zone"
				;;

			unblock)
				iptables -D INPUT -m set --match-set "$ipset_name" src -j DROP 2>/dev/null

				if ipset list "$ipset_name" &> /dev/null; then
					ipset destroy "$ipset_name"
				fi

				echo "宸叉垚鍔熻В闄?$country_code 鐨?IP 鍦板潃闄愬埗"
				;;

			*)
				echo "鐢ㄦ硶: manage_country_rules {block|allow|unblock} <country_code...>"
				;;
		esac
	done
}










iptables_panel() {
  root_use
  install iptables
  save_iptables_rules
  while true; do
		  clear
		  echo "楂樼骇闃茬伀澧欑鐞?
		  send_stats "楂樼骇闃茬伀澧欑鐞?
		  echo "------------------------"
		  iptables -L INPUT
		  echo ""
		  echo "闃茬伀澧欑鐞?
		  echo "------------------------"
		  echo "1.  寮€鏀炬寚瀹氱鍙?                2.  鍏抽棴鎸囧畾绔彛"
		  echo "3.  寮€鏀炬墍鏈夌鍙?                4.  鍏抽棴鎵€鏈夌鍙?
		  echo "------------------------"
		  echo "5.  IP鐧藉悕鍗?                 	 6.  IP榛戝悕鍗?
		  echo "7.  娓呴櫎鎸囧畾IP"
		  echo "------------------------"
		  echo "11. 鍏佽PING                  	 12. 绂佹PING"
		  echo "------------------------"
		  echo "13. 鍚姩DDOS闃插尽                 14. 鍏抽棴DDOS闃插尽"
		  echo "------------------------"
		  echo "15. 闃绘鎸囧畾鍥藉IP               16. 浠呭厑璁告寚瀹氬浗瀹禝P"
		  echo "17. 瑙ｉ櫎鎸囧畾鍥藉IP闄愬埗"
		  echo "------------------------"
		  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
		  echo "------------------------"
		  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice
		  case $sub_choice in
			  1)
				  read -e -p "璇疯緭鍏ュ紑鏀剧殑绔彛鍙? " o_port
				  open_port $o_port
				  send_stats "寮€鏀炬寚瀹氱鍙?
				  ;;
			  2)
				  read -e -p "璇疯緭鍏ュ叧闂殑绔彛鍙? " c_port
				  close_port $c_port
				  send_stats "鍏抽棴鎸囧畾绔彛"
				  ;;
			  3)
				  # 寮€鏀炬墍鏈夌鍙?
				  current_port=$(grep -E '^ *Port [0-9]+' /etc/ssh/sshd_config | awk '{print $2}')
				  iptables -F
				  iptables -X
				  iptables -P INPUT ACCEPT
				  iptables -P FORWARD ACCEPT
				  iptables -P OUTPUT ACCEPT
				  iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
				  iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
				  iptables -A INPUT -i lo -j ACCEPT
				  iptables -A FORWARD -i lo -j ACCEPT
				  iptables -A INPUT -p tcp --dport $current_port -j ACCEPT
				  iptables-save > /etc/iptables/rules.v4
				  send_stats "寮€鏀炬墍鏈夌鍙?
				  ;;
			  4)
				  # 鍏抽棴鎵€鏈夌鍙?
				  current_port=$(grep -E '^ *Port [0-9]+' /etc/ssh/sshd_config | awk '{print $2}')
				  iptables -F
				  iptables -X
				  iptables -P INPUT DROP
				  iptables -P FORWARD DROP
				  iptables -P OUTPUT ACCEPT
				  iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
				  iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
				  iptables -A INPUT -i lo -j ACCEPT
				  iptables -A FORWARD -i lo -j ACCEPT
				  iptables -A INPUT -p tcp --dport $current_port -j ACCEPT
				  iptables-save > /etc/iptables/rules.v4
				  send_stats "鍏抽棴鎵€鏈夌鍙?
				  ;;

			  5)
				  # IP 鐧藉悕鍗?
				  read -e -p "璇疯緭鍏ユ斁琛岀殑IP鎴朓P娈? " o_ip
				  allow_ip $o_ip
				  ;;
			  6)
				  # IP 榛戝悕鍗?
				  read -e -p "璇疯緭鍏ュ皝閿佺殑IP鎴朓P娈? " c_ip
				  block_ip $c_ip
				  ;;
			  7)
				  # 娓呴櫎鎸囧畾 IP
				  read -e -p "璇疯緭鍏ユ竻闄ょ殑IP: " d_ip
				  iptables -D INPUT -s $d_ip -j ACCEPT 2>/dev/null
				  iptables -D INPUT -s $d_ip -j DROP 2>/dev/null
				  iptables-save > /etc/iptables/rules.v4
				  send_stats "娓呴櫎鎸囧畾IP"
				  ;;
			  11)
				  # 鍏佽 PING
				  iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
				  iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT
				  iptables-save > /etc/iptables/rules.v4
				  send_stats "鍏佽PING"
				  ;;
			  12)
				  # 绂佺敤 PING
				  iptables -D INPUT -p icmp --icmp-type echo-request -j ACCEPT 2>/dev/null
				  iptables -D OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT 2>/dev/null
				  iptables-save > /etc/iptables/rules.v4
				  send_stats "绂佺敤PING"
				  ;;
			  13)
				  enable_ddos_defense
				  ;;
			  14)
				  disable_ddos_defense
				  ;;

			  15)
				  read -e -p "璇疯緭鍏ラ樆姝㈢殑鍥藉浠ｇ爜锛堝涓浗瀹朵唬鐮佸彲鐢ㄧ┖鏍奸殧寮€濡?CN US JP锛? " country_code
				  manage_country_rules block $country_code
				  send_stats "鍏佽鍥藉 $country_code 鐨処P"
				  ;;
			  16)
				  read -e -p "璇疯緭鍏ュ厑璁哥殑鍥藉浠ｇ爜锛堝涓浗瀹朵唬鐮佸彲鐢ㄧ┖鏍奸殧寮€濡?CN US JP锛? " country_code
				  manage_country_rules allow $country_code
				  send_stats "闃绘鍥藉 $country_code 鐨処P"
				  ;;

			  17)
				  read -e -p "璇疯緭鍏ユ竻闄ょ殑鍥藉浠ｇ爜锛堝涓浗瀹朵唬鐮佸彲鐢ㄧ┖鏍奸殧寮€濡?CN US JP锛? " country_code
				  manage_country_rules unblock $country_code
				  send_stats "娓呴櫎鍥藉 $country_code 鐨処P"
				  ;;

			  *)
				  break  # 璺冲嚭寰幆锛岄€€鍑鸿彍鍗?
				  ;;
		  esac
  done

}






add_swap() {
	local new_swap=$1  # 鑾峰彇浼犲叆鐨勫弬鏁?

	# 鑾峰彇褰撳墠绯荤粺涓墍鏈夌殑 swap 鍒嗗尯
	local swap_partitions=$(grep -E '^/dev/' /proc/swaps | awk '{print $1}')

	# 閬嶅巻骞跺垹闄ゆ墍鏈夌殑 swap 鍒嗗尯
	for partition in $swap_partitions; do
		swapoff "$partition"
		wipefs -a "$partition"
		mkswap -f "$partition"
	done

	# 纭繚 /swapfile 涓嶅啀琚娇鐢?
	swapoff /swapfile

	# 鍒犻櫎鏃х殑 /swapfile
	rm -f /swapfile

	# 鍒涘缓鏂扮殑 swap 鍒嗗尯
	fallocate -l ${new_swap}M /swapfile
	chmod 600 /swapfile
	mkswap /swapfile
	swapon /swapfile

	sed -i '/\/swapfile/d' /etc/fstab
	echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

	if [ -f /etc/alpine-release ]; then
		echo "nohup swapon /swapfile" > /etc/local.d/swap.start
		chmod +x /etc/local.d/swap.start
		rc-update add local
	fi

	echo -e "铏氭嫙鍐呭瓨澶у皬宸茶皟鏁翠负${gl_huang}${new_swap}${gl_bai}M"
}




check_swap() {

local swap_total=$(free -m | awk 'NR==3{print $2}')

# 鍒ゆ柇鏄惁闇€瑕佸垱寤鸿櫄鎷熷唴瀛?
[ "$swap_total" -gt 0 ] || add_swap 1024


}









ldnmp_v() {

	  # 鑾峰彇nginx鐗堟湰
	  local nginx_version=$(docker exec nginx nginx -v 2>&1)
	  local nginx_version=$(echo "$nginx_version" | grep -oP "nginx/\K[0-9]+\.[0-9]+\.[0-9]+")
	  echo -n -e "nginx : ${gl_huang}v$nginx_version${gl_bai}"

	  # 鑾峰彇mysql鐗堟湰
	  local dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
	  local mysql_version=$(docker exec mysql mysql -u root -p"$dbrootpasswd" -e "SELECT VERSION();" 2>/dev/null | tail -n 1)
	  echo -n -e "            mysql : ${gl_huang}v$mysql_version${gl_bai}"

	  # 鑾峰彇php鐗堟湰
	  local php_version=$(docker exec php php -v 2>/dev/null | grep -oP "PHP \K[0-9]+\.[0-9]+\.[0-9]+")
	  echo -n -e "            php : ${gl_huang}v$php_version${gl_bai}"

	  # 鑾峰彇redis鐗堟湰
	  local redis_version=$(docker exec redis redis-server -v 2>&1 | grep -oP "v=+\K[0-9]+\.[0-9]+")
	  echo -e "            redis : ${gl_huang}v$redis_version${gl_bai}"

	  echo "------------------------"
	  echo ""

}



install_ldnmp_conf() {

  # 鍒涘缓蹇呰鐨勭洰褰曞拰鏂囦欢
  cd /home && mkdir -p web/html web/mysql web/certs web/conf.d web/stream.d web/redis web/log/nginx web/letsencrypt && touch web/docker-compose.yml
  wget -O /home/web/nginx.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/nginx10.conf
  wget -O /home/web/conf.d/default.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/default10.conf

  default_server_ssl

  # 涓嬭浇 docker-compose.yml 鏂囦欢骞惰繘琛屾浛鎹?
  wget -O /home/web/docker-compose.yml ${gh_proxy}raw.githubusercontent.com/kejilion/docker/main/LNMP-docker-compose-10.yml
  dbrootpasswd=$(openssl rand -base64 16) ; dbuse=$(openssl rand -hex 4) ; dbusepasswd=$(openssl rand -base64 8)

  # 鍦?docker-compose.yml 鏂囦欢涓繘琛屾浛鎹?
  sed -i "s#webroot#$dbrootpasswd#g" /home/web/docker-compose.yml
  sed -i "s#kejilionYYDS#$dbusepasswd#g" /home/web/docker-compose.yml
  sed -i "s#kejilion#$dbuse#g" /home/web/docker-compose.yml

}


update_docker_compose_with_db_creds() {

  cp /home/web/docker-compose.yml /home/web/docker-compose1.yml

  if ! grep -q "letsencrypt" /home/web/docker-compose.yml; then
	wget -O /home/web/docker-compose.yml ${gh_proxy}raw.githubusercontent.com/kejilion/docker/main/LNMP-docker-compose-10.yml

  	dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose1.yml | tr -d '[:space:]')
  	dbuse=$(grep -oP 'MYSQL_USER:\s*\K.*' /home/web/docker-compose1.yml | tr -d '[:space:]')
  	dbusepasswd=$(grep -oP 'MYSQL_PASSWORD:\s*\K.*' /home/web/docker-compose1.yml | tr -d '[:space:]')

	sed -i "s#webroot#$dbrootpasswd#g" /home/web/docker-compose.yml
	sed -i "s#kejilionYYDS#$dbusepasswd#g" /home/web/docker-compose.yml
	sed -i "s#kejilion#$dbuse#g" /home/web/docker-compose.yml
  fi

  if grep -q "kjlion/nginx:alpine" /home/web/docker-compose1.yml; then
  	sed -i 's|kjlion/nginx:alpine|nginx:alpine|g' /home/web/docker-compose.yml  > /dev/null 2>&1
	sed -i 's|nginx:alpine|kjlion/nginx:alpine|g' /home/web/docker-compose.yml  > /dev/null 2>&1
  fi

}





auto_optimize_dns() {
	# 鑾峰彇鍥藉浠ｇ爜锛堝 CN銆乁S 绛夛級
	local country=$(curl -s ipinfo.io/country)

	# 鏍规嵁鍥藉璁剧疆 DNS
	if [ "$country" = "CN" ]; then
		local dns1_ipv4="223.5.5.5"
		local dns2_ipv4="183.60.83.19"
		local dns1_ipv6="2400:3200::1"
		local dns2_ipv6="2400:da00::6666"
	else
		local dns1_ipv4="1.1.1.1"
		local dns2_ipv4="8.8.8.8"
		local dns1_ipv6="2606:4700:4700::1111"
		local dns2_ipv6="2001:4860:4860::8888"
	fi

	set_dns


}


prefer_ipv4() {
grep -q '^precedence ::ffff:0:0/96  100' /etc/gai.conf 2>/dev/null \
	|| echo 'precedence ::ffff:0:0/96  100' >> /etc/gai.conf
echo "宸插垏鎹负 IPv4 浼樺厛"
send_stats "宸插垏鎹负 IPv4 浼樺厛"
}




install_ldnmp() {

	  update_docker_compose_with_db_creds

	  cd /home/web && docker compose up -d
	  sleep 1
  	  crontab -l 2>/dev/null | grep -v 'logrotate' | crontab -
  	  (crontab -l 2>/dev/null; echo '0 2 * * * docker exec nginx apk add logrotate && docker exec nginx logrotate -f /etc/logrotate.conf') | crontab -

	  fix_phpfpm_conf php
	  fix_phpfpm_conf php74

	  # mysql璋冧紭
	  wget -O /home/custom_mysql_config.cnf ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/custom_mysql_config-1.cnf
	  docker cp /home/custom_mysql_config.cnf mysql:/etc/mysql/conf.d/
	  rm -rf /home/custom_mysql_config.cnf



	  restart_ldnmp
	  sleep 2

	  clear
	  echo "LDNMP鐜瀹夎瀹屾瘯"
	  echo "------------------------"
	  ldnmp_v

}


install_certbot() {

	cd ~
	curl -sS -O ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/auto_cert_renewal.sh
	chmod +x auto_cert_renewal.sh

	check_crontab_installed
	local cron_job="0 0 * * * ~/auto_cert_renewal.sh"
	crontab -l 2>/dev/null | grep -vF "$cron_job" | crontab -
	(crontab -l 2>/dev/null; echo "$cron_job") | crontab -
	echo "缁浠诲姟宸叉洿鏂?
}


install_ssltls() {
	  docker stop nginx > /dev/null 2>&1
	  cd ~

	  local file_path="/etc/letsencrypt/live/$yuming/fullchain.pem"
	  if [ ! -f "$file_path" ]; then
		 	local ipv4_pattern='^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'
			local ipv6_pattern='^(([0-9A-Fa-f]{1,4}:){1,7}:|([0-9A-Fa-f]{1,4}:){7,7}[0-9A-Fa-f]{1,4}|::1)$'
			if [[ ($yuming =~ $ipv4_pattern || $yuming =~ $ipv6_pattern) ]]; then
				mkdir -p /etc/letsencrypt/live/$yuming/
				if command -v dnf &>/dev/null || command -v yum &>/dev/null; then
					openssl req -x509 -nodes -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -keyout /etc/letsencrypt/live/$yuming/privkey.pem -out /etc/letsencrypt/live/$yuming/fullchain.pem -days 5475 -subj "/C=US/ST=State/L=City/O=Organization/OU=Organizational Unit/CN=Common Name"
				else
					openssl genpkey -algorithm Ed25519 -out /etc/letsencrypt/live/$yuming/privkey.pem
					openssl req -x509 -key /etc/letsencrypt/live/$yuming/privkey.pem -out /etc/letsencrypt/live/$yuming/fullchain.pem -days 5475 -subj "/C=US/ST=State/L=City/O=Organization/OU=Organizational Unit/CN=Common Name"
				fi
			else
				docker run --rm -p 80:80 -v /etc/letsencrypt/:/etc/letsencrypt certbot/certbot certonly --standalone -d "$yuming" --email your@email.com --agree-tos --no-eff-email --force-renewal --key-type ecdsa
			fi
	  fi
	  mkdir -p /home/web/certs/
	  cp /etc/letsencrypt/live/$yuming/fullchain.pem /home/web/certs/${yuming}_cert.pem > /dev/null 2>&1
	  cp /etc/letsencrypt/live/$yuming/privkey.pem /home/web/certs/${yuming}_key.pem > /dev/null 2>&1

	  docker start nginx > /dev/null 2>&1
}



install_ssltls_text() {
	echo -e "${gl_huang}$yuming 鍏挜淇℃伅${gl_bai}"
	cat /etc/letsencrypt/live/$yuming/fullchain.pem
	echo ""
	echo -e "${gl_huang}$yuming 绉侀挜淇℃伅${gl_bai}"
	cat /etc/letsencrypt/live/$yuming/privkey.pem
	echo ""
	echo -e "${gl_huang}璇佷功瀛樻斁璺緞${gl_bai}"
	echo "鍏挜: /etc/letsencrypt/live/$yuming/fullchain.pem"
	echo "绉侀挜: /etc/letsencrypt/live/$yuming/privkey.pem"
	echo ""
}





add_ssl() {
echo -e "${gl_huang}蹇€熺敵璇稴SL璇佷功锛岃繃鏈熷墠鑷姩缁${gl_bai}"
yuming="${1:-}"
if [ -z "$yuming" ]; then
	add_yuming
fi
install_docker
install_certbot
docker run --rm -v /etc/letsencrypt/:/etc/letsencrypt certbot/certbot delete --cert-name "$yuming" -n 2>/dev/null
install_ssltls
certs_status
install_ssltls_text
ssl_ps
}


ssl_ps() {
	echo -e "${gl_huang}宸茬敵璇风殑璇佷功鍒版湡鎯呭喌${gl_bai}"
	echo "绔欑偣淇℃伅                      璇佷功鍒版湡鏃堕棿"
	echo "------------------------"
	for cert_dir in /etc/letsencrypt/live/*; do
	  local cert_file="$cert_dir/fullchain.pem"
	  if [ -f "$cert_file" ]; then
		local domain=$(basename "$cert_dir")
		local expire_date=$(openssl x509 -noout -enddate -in "$cert_file" | awk -F'=' '{print $2}')
		local formatted_date=$(date -d "$expire_date" '+%Y-%m-%d')
		printf "%-30s%s\n" "$domain" "$formatted_date"
	  fi
	done
	echo ""
}




default_server_ssl() {
install openssl

if command -v dnf &>/dev/null || command -v yum &>/dev/null; then
	openssl req -x509 -nodes -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -keyout /home/web/certs/default_server.key -out /home/web/certs/default_server.crt -days 5475 -subj "/C=US/ST=State/L=City/O=Organization/OU=Organizational Unit/CN=Common Name"
else
	openssl genpkey -algorithm Ed25519 -out /home/web/certs/default_server.key
	openssl req -x509 -key /home/web/certs/default_server.key -out /home/web/certs/default_server.crt -days 5475 -subj "/C=US/ST=State/L=City/O=Organization/OU=Organizational Unit/CN=Common Name"
fi

openssl rand -out /home/web/certs/ticket12.key 48
openssl rand -out /home/web/certs/ticket13.key 80

}


certs_status() {

	sleep 1

	local file_path="/etc/letsencrypt/live/$yuming/fullchain.pem"
	if [ -f "$file_path" ]; then
		send_stats "鍩熷悕璇佷功鐢宠鎴愬姛"
	else
		send_stats "鍩熷悕璇佷功鐢宠澶辫触"
		echo -e "${gl_hong}娉ㄦ剰: ${gl_bai}璇佷功鐢宠澶辫触锛岃妫€鏌ヤ互涓嬪彲鑳藉師鍥犲苟閲嶈瘯锛?
		echo -e "1. 鍩熷悕鎷煎啓閿欒 鉃?璇锋鏌ュ煙鍚嶈緭鍏ユ槸鍚︽纭?
		echo -e "2. DNS瑙ｆ瀽闂 鉃?纭鍩熷悕宸叉纭В鏋愬埌鏈湇鍔″櫒IP"
		echo -e "3. 缃戠粶閰嶇疆闂 鉃?濡備娇鐢–loudflare Warp绛夎櫄鎷熺綉缁滆鏆傛椂鍏抽棴"
		echo -e "4. 闃茬伀澧欓檺鍒?鉃?妫€鏌?0/443绔彛鏄惁寮€鏀撅紝纭繚楠岃瘉鍙闂?
		echo -e "5. 鐢宠娆℃暟瓒呴檺 鉃?Let's Encrypt鏈夋瘡鍛ㄩ檺棰?5娆?鍩熷悕/鍛?"
		echo -e "6. 鍥藉唴澶囨闄愬埗 鉃?涓浗澶ч檰鐜璇风‘璁ゅ煙鍚嶆槸鍚﹀妗?
		echo "------------------------"
		echo "1. 閲嶆柊鐢宠        2. 瀵煎叆宸叉湁璇佷功        0. 閫€鍑?
		echo "------------------------"
		read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice
		case $sub_choice in
	  	  1)
	  	  	send_stats "閲嶆柊鐢宠"
		  	echo "璇峰啀娆″皾璇曢儴缃?$webname"
		  	add_yuming
		  	install_ssltls
		  	certs_status

	  		  ;;
	  	  2)
	  	  	send_stats "瀵煎叆宸叉湁璇佷功"

			# 瀹氫箟鏂囦欢璺緞
			local cert_file="/home/web/certs/${yuming}_cert.pem"
			local key_file="/home/web/certs/${yuming}_key.pem"

			mkdir -p /home/web/certs

			# 1. 杈撳叆璇佷功 (ECC 鍜?RSA 璇佷功寮€澶撮兘鏄?BEGIN CERTIFICATE)
			echo "璇风矘璐?璇佷功 (CRT/PEM) 鍐呭 (鎸変袱娆″洖杞︾粨鏉?锛?
			local cert_content=""
			while IFS= read -r line; do
				[[ -z "$line" && "$cert_content" == *"-----BEGIN"* ]] && break
				cert_content+="${line}"$'\n'
			done

			# 2. 杈撳叆绉侀挜 (鍏煎 RSA, ECC, PKCS#8)
			echo "璇风矘璐?璇佷功绉侀挜 (Private Key) 鍐呭 (鎸変袱娆″洖杞︾粨鏉?锛?
			local key_content=""
			while IFS= read -r line; do
				[[ -z "$line" && "$key_content" == *"-----BEGIN"* ]] && break
				key_content+="${line}"$'\n'
			done

			# 3. 鏅鸿兘鏍￠獙
			# 鍙鍖呭惈 "BEGIN CERTIFICATE" 鍜?"PRIVATE KEY" 鍗冲彲閫氳繃
			if [[ "$cert_content" == *"-----BEGIN CERTIFICATE-----"* && "$key_content" == *"PRIVATE KEY-----"* ]]; then
				echo -n "$cert_content" > "$cert_file"
				echo -n "$key_content" > "$key_file"

				chmod 644 "$cert_file"
				chmod 600 "$key_file"

				# 璇嗗埆褰撳墠璇佷功绫诲瀷骞舵樉绀?
				if [[ "$key_content" == *"EC PRIVATE KEY"* ]]; then
					echo "妫€娴嬪埌 ECC 璇佷功宸叉垚鍔熶繚瀛樸€?
				else
					echo "妫€娴嬪埌 RSA 璇佷功宸叉垚鍔熶繚瀛樸€?
				fi
				auth_method="ssl_imported"
			else
				echo "閿欒锛氭棤鏁堢殑璇佷功鎴栫閽ユ牸寮忥紒"
				certs_status
			fi
	  		  ;;
	  	  *)
		  	  exit
	  		  ;;
		esac
	fi

}


repeat_add_yuming() {
if [ -e /home/web/conf.d/$yuming.conf ]; then
  send_stats "鍩熷悕閲嶅浣跨敤"
  web_del "${yuming}" > /dev/null 2>&1
fi

}


add_yuming() {
	  ip_address
	  echo -e "鍏堝皢鍩熷悕瑙ｆ瀽鍒版湰鏈篒P: ${gl_huang}$ipv4_address  $ipv6_address${gl_bai}"
	  read -e -p "璇疯緭鍏ヤ綘鐨処P鎴栬€呰В鏋愯繃鐨勫煙鍚? " yuming
}


check_ip_and_get_access_port() {
	local yuming="$1"

	local ipv4_pattern='^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'
	local ipv6_pattern='^(([0-9A-Fa-f]{1,4}:){1,7}:|([0-9A-Fa-f]{1,4}:){7,7}[0-9A-Fa-f]{1,4}|::1)$'

	if [[ "$yuming" =~ $ipv4_pattern || "$yuming" =~ $ipv6_pattern ]]; then
		read -e -p "璇疯緭鍏ヨ闂?鐩戝惉绔彛锛屽洖杞﹂粯璁や娇鐢?80: " access_port
		access_port=${access_port:-80}
	fi
}



update_nginx_listen_port() {
	local yuming="$1"
	local access_port="$2"
	local conf="/home/web/conf.d/${yuming}.conf"

	# 濡傛灉 access_port 涓虹┖锛屽垯璺宠繃
	[ -z "$access_port" ] && return 0

	# 鍒犻櫎鎵€鏈?listen 琛?
	sed -i '/^[[:space:]]*listen[[:space:]]\+/d' "$conf"

	# 鍦?server { 鍚庢彃鍏ユ柊鐨?listen
	sed -i "/server {/a\\
	listen ${access_port};\\
	listen [::]:${access_port};
" "$conf"
}



add_db() {
	  dbname=$(echo "$yuming" | sed -e 's/[^A-Za-z0-9]/_/g')
	  dbname="${dbname}"

	  dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
	  dbuse=$(grep -oP 'MYSQL_USER:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
	  dbusepasswd=$(grep -oP 'MYSQL_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
	  docker exec mysql mysql -u root -p"$dbrootpasswd" -e "CREATE DATABASE $dbname; GRANT ALL PRIVILEGES ON $dbname.* TO \"$dbuse\"@\"%\";"
}


restart_ldnmp() {
	  docker exec nginx chown -R nginx:nginx /var/www/html > /dev/null 2>&1
	  docker exec nginx mkdir -p /var/cache/nginx/proxy > /dev/null 2>&1
	  docker exec nginx mkdir -p /var/cache/nginx/fastcgi > /dev/null 2>&1
	  docker exec nginx chown -R nginx:nginx /var/cache/nginx/proxy > /dev/null 2>&1
	  docker exec nginx chown -R nginx:nginx /var/cache/nginx/fastcgi > /dev/null 2>&1
	  docker exec php chown -R www-data:www-data /var/www/html > /dev/null 2>&1
	  docker exec php74 chown -R www-data:www-data /var/www/html > /dev/null 2>&1
	  cd /home/web && docker compose restart


}

nginx_upgrade() {

  local ldnmp_pods="nginx"
  cd /home/web/
  docker rm -f $ldnmp_pods > /dev/null 2>&1
  docker images --filter=reference="kjlion/${ldnmp_pods}*" -q | xargs docker rmi > /dev/null 2>&1
  docker images --filter=reference="${ldnmp_pods}*" -q | xargs docker rmi > /dev/null 2>&1
  docker compose up -d --force-recreate $ldnmp_pods
  crontab -l 2>/dev/null | grep -v 'logrotate' | crontab -
  (crontab -l 2>/dev/null; echo '0 2 * * * docker exec nginx apk add logrotate && docker exec nginx logrotate -f /etc/logrotate.conf') | crontab -
  docker exec nginx chown -R nginx:nginx /var/www/html
  docker exec nginx mkdir -p /var/cache/nginx/proxy
  docker exec nginx mkdir -p /var/cache/nginx/fastcgi
  docker exec nginx chown -R nginx:nginx /var/cache/nginx/proxy
  docker exec nginx chown -R nginx:nginx /var/cache/nginx/fastcgi
  docker restart $ldnmp_pods > /dev/null 2>&1

  send_stats "鏇存柊$ldnmp_pods"
  echo "鏇存柊${ldnmp_pods}瀹屾垚"

}

phpmyadmin_upgrade() {
  local ldnmp_pods="phpmyadmin"
  local local docker_port=8877
  local dbuse=$(grep -oP 'MYSQL_USER:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
  local dbusepasswd=$(grep -oP 'MYSQL_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')

  cd /home/web/
  docker rm -f $ldnmp_pods > /dev/null 2>&1
  docker images --filter=reference="$ldnmp_pods*" -q | xargs docker rmi > /dev/null 2>&1
  curl -sS -O ${gh_proxy}raw.githubusercontent.com/kejilion/docker/refs/heads/main/docker-compose.phpmyadmin.yml
  docker compose -f docker-compose.phpmyadmin.yml up -d
  clear
  ip_address

  check_docker_app_ip
  echo "鐧诲綍淇℃伅: "
  echo "鐢ㄦ埛鍚? $dbuse"
  echo "瀵嗙爜: $dbusepasswd"
  echo
  send_stats "鍚姩$ldnmp_pods"
}


cf_purge_cache() {
  local CONFIG_FILE="/home/web/config/cf-purge-cache.txt"
  local API_TOKEN
  local EMAIL
  local ZONE_IDS

  # 妫€鏌ラ厤缃枃浠舵槸鍚﹀瓨鍦?
  if [ -f "$CONFIG_FILE" ]; then
	# 浠庨厤缃枃浠惰鍙?API_TOKEN 鍜?zone_id
	read API_TOKEN EMAIL ZONE_IDS < "$CONFIG_FILE"
	# 灏?ZONE_IDS 杞崲涓烘暟缁?
	ZONE_IDS=($ZONE_IDS)
  else
	# 鎻愮ず鐢ㄦ埛鏄惁娓呯悊缂撳瓨
	read -e -p "闇€瑕佹竻鐞?Cloudflare 鐨勭紦瀛樺悧锛燂紙y/n锛? " answer
	if [[ "$answer" == "y" ]]; then
	  echo "CF淇℃伅淇濆瓨鍦?CONFIG_FILE锛屽彲浠ュ悗鏈熶慨鏀笴F淇℃伅"
	  read -e -p "璇疯緭鍏ヤ綘鐨?API_TOKEN: " API_TOKEN
	  read -e -p "璇疯緭鍏ヤ綘鐨凜F鐢ㄦ埛鍚? " EMAIL
	  read -e -p "璇疯緭鍏?zone_id锛堝涓敤绌烘牸鍒嗛殧锛? " -a ZONE_IDS

	  mkdir -p /home/web/config/
	  echo "$API_TOKEN $EMAIL ${ZONE_IDS[*]}" > "$CONFIG_FILE"
	fi
  fi

  # 寰幆閬嶅巻姣忎釜 zone_id 骞舵墽琛屾竻闄ょ紦瀛樺懡浠?
  for ZONE_ID in "${ZONE_IDS[@]}"; do
	echo "姝ｅ湪娓呴櫎缂撳瓨 for zone_id: $ZONE_ID"
	curl -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/purge_cache" \
	-H "X-Auth-Email: $EMAIL" \
	-H "X-Auth-Key: $API_TOKEN" \
	-H "Content-Type: application/json" \
	--data '{"purge_everything":true}'
  done

  echo "缂撳瓨娓呴櫎璇锋眰宸插彂閫佸畬姣曘€?
}



web_cache() {
  send_stats "娓呯悊绔欑偣缂撳瓨"
  cf_purge_cache
  cd /home/web && docker compose restart
}



web_del() {

	send_stats "鍒犻櫎绔欑偣鏁版嵁"
	yuming_list="${1:-}"
	if [ -z "$yuming_list" ]; then
		read -e -p "鍒犻櫎绔欑偣鏁版嵁锛岃杈撳叆浣犵殑鍩熷悕锛堝涓煙鍚嶇敤绌烘牸闅斿紑锛? " yuming_list
		if [[ -z "$yuming_list" ]]; then
			return
		fi
	fi

	for yuming in $yuming_list; do
		echo "姝ｅ湪鍒犻櫎鍩熷悕: $yuming"
		rm -r /home/web/html/$yuming > /dev/null 2>&1
		rm /home/web/conf.d/$yuming.conf > /dev/null 2>&1
		rm /home/web/certs/${yuming}_key.pem > /dev/null 2>&1
		rm /home/web/certs/${yuming}_cert.pem > /dev/null 2>&1

		# 灏嗗煙鍚嶈浆鎹负鏁版嵁搴撳悕
		dbname=$(echo "$yuming" | sed -e 's/[^A-Za-z0-9]/_/g')
		dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')

		# 鍒犻櫎鏁版嵁搴撳墠妫€鏌ユ槸鍚﹀瓨鍦紝閬垮厤鎶ラ敊
		echo "姝ｅ湪鍒犻櫎鏁版嵁搴? $dbname"
		docker exec mysql mysql -u root -p"$dbrootpasswd" -e "DROP DATABASE ${dbname};" > /dev/null 2>&1
	done

	docker exec nginx nginx -s reload

}


nginx_waf() {
	local mode=$1

	if ! grep -q "kjlion/nginx:alpine" /home/web/docker-compose.yml; then
		wget -O /home/web/nginx.conf "${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/nginx10.conf"
	fi

	# 鏍规嵁 mode 鍙傛暟鏉ュ喅瀹氬紑鍚垨鍏抽棴 WAF
	if [ "$mode" == "on" ]; then
		# 寮€鍚?WAF锛氬幓鎺夋敞閲?
		sed -i 's|# load_module /etc/nginx/modules/ngx_http_modsecurity_module.so;|load_module /etc/nginx/modules/ngx_http_modsecurity_module.so;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)# modsecurity on;|\1modsecurity on;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)# modsecurity_rules_file /etc/nginx/modsec/modsecurity.conf;|\1modsecurity_rules_file /etc/nginx/modsec/modsecurity.conf;|' /home/web/nginx.conf > /dev/null 2>&1
	elif [ "$mode" == "off" ]; then
		# 鍏抽棴 WAF锛氬姞涓婃敞閲?
		sed -i 's|^load_module /etc/nginx/modules/ngx_http_modsecurity_module.so;|# load_module /etc/nginx/modules/ngx_http_modsecurity_module.so;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)modsecurity on;|\1# modsecurity on;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)modsecurity_rules_file /etc/nginx/modsec/modsecurity.conf;|\1# modsecurity_rules_file /etc/nginx/modsec/modsecurity.conf;|' /home/web/nginx.conf > /dev/null 2>&1
	else
		echo "鏃犳晥鐨勫弬鏁帮細浣跨敤 'on' 鎴?'off'"
		return 1
	fi

	# 妫€鏌?nginx 闀滃儚骞舵牴鎹儏鍐靛鐞?
	if grep -q "kjlion/nginx:alpine" /home/web/docker-compose.yml; then
		docker exec nginx nginx -s reload
	else
		sed -i 's|nginx:alpine|kjlion/nginx:alpine|g' /home/web/docker-compose.yml
		nginx_upgrade
	fi

}

check_waf_status() {
	if grep -q "^\s*#\s*modsecurity on;" /home/web/nginx.conf; then
		waf_status=""
	elif grep -q "modsecurity on;" /home/web/nginx.conf; then
		waf_status=" WAF宸插紑鍚?
	else
		waf_status=""
	fi
}


check_cf_mode() {
	if [ -f "/etc/fail2ban/action.d/cloudflare-docker.conf" ]; then
		CFmessage=" cf妯″紡宸插紑鍚?
	else
		CFmessage=""
	fi
}


nginx_http_on() {

local ipv4_pattern='^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'
local ipv6_pattern='^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|(2[0-4][0-9]|[01]?[0-9][0-9]?))|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|(2[0-4][0-9]|[01]?[0-9][0-9]?))|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|(2[0-4][0-9]|[01]?[0-9][0-9]?))|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|(2[0-4][0-9]|[01]?[0-9][0-9]?))))$'
if [[ ($yuming =~ $ipv4_pattern || $yuming =~ $ipv6_pattern) ]]; then
	sed -i '/if (\$scheme = http) {/,/}/s/^/#/' /home/web/conf.d/${yuming}.conf
fi

}


patch_wp_memory_limit() {
  local MEMORY_LIMIT="${1:-256M}"      # 绗竴涓弬鏁帮紝榛樿256M
  local MAX_MEMORY_LIMIT="${2:-256M}"  # 绗簩涓弬鏁帮紝榛樿256M
  local TARGET_DIR="/home/web/html"    # 璺緞鍐欐

  find "$TARGET_DIR" -type f -name "wp-config.php" | while read -r FILE; do
	# 鍒犻櫎鏃у畾涔?
	sed -i "/define(['\"]WP_MEMORY_LIMIT['\"].*/d" "$FILE"
	sed -i "/define(['\"]WP_MAX_MEMORY_LIMIT['\"].*/d" "$FILE"

	# 鎻掑叆鏂板畾涔夛紝鏀惧湪鍚?"Happy publishing" 鐨勮鍓?
	awk -v insert="define('WP_MEMORY_LIMIT', '$MEMORY_LIMIT');\ndefine('WP_MAX_MEMORY_LIMIT', '$MAX_MEMORY_LIMIT');" \
	'
	  /Happy publishing/ {
		print insert
	  }
	  { print }
	' "$FILE" > "$FILE.tmp" && mv -f "$FILE.tmp" "$FILE"

	echo "[+] Replaced WP_MEMORY_LIMIT in $FILE"
  done
}




patch_wp_debug() {
  local DEBUG="${1:-false}"           # 绗竴涓弬鏁帮紝榛樿false
  local DEBUG_DISPLAY="${2:-false}"   # 绗簩涓弬鏁帮紝榛樿false
  local DEBUG_LOG="${3:-false}"       # 绗笁涓弬鏁帮紝榛樿false
  local TARGET_DIR="/home/web/html"   # 璺緞鍐欐

  find "$TARGET_DIR" -type f -name "wp-config.php" | while read -r FILE; do
	# 鍒犻櫎鏃у畾涔?
	sed -i "/define(['\"]WP_DEBUG['\"].*/d" "$FILE"
	sed -i "/define(['\"]WP_DEBUG_DISPLAY['\"].*/d" "$FILE"
	sed -i "/define(['\"]WP_DEBUG_LOG['\"].*/d" "$FILE"

	# 鎻掑叆鏂板畾涔夛紝鏀惧湪鍚?"Happy publishing" 鐨勮鍓?
	awk -v insert="define('WP_DEBUG_DISPLAY', $DEBUG_DISPLAY);\ndefine('WP_DEBUG_LOG', $DEBUG_LOG);" \
	'
	  /Happy publishing/ {
		print insert
	  }
	  { print }
	' "$FILE" > "$FILE.tmp" && mv -f "$FILE.tmp" "$FILE"

	echo "[+] Replaced WP_DEBUG settings in $FILE"
  done
}




patch_wp_url() {
  local HOME_URL="$1"
  local SITE_URL="$2"
  local TARGET_DIR="/home/web/html"

  find "$TARGET_DIR" -type f -name "wp-config-sample.php" | while read -r FILE; do
	# 鍒犻櫎鏃у畾涔?
	sed -i "/define(['\"]WP_HOME['\"].*/d" "$FILE"
	sed -i "/define(['\"]WP_SITEURL['\"].*/d" "$FILE"

	# 鐢熸垚鎻掑叆鍐呭
	INSERT="
define('WP_HOME', '$HOME_URL');
define('WP_SITEURL', '$SITE_URL');
"

	# 鎻掑叆鍒?鈥淗appy publishing鈥?涔嬪墠
	awk -v insert="$INSERT" '
	  /Happy publishing/ {
		print insert
	  }
	  { print }
	' "$FILE" > "$FILE.tmp" && mv -f "$FILE.tmp" "$FILE"

	echo "[+] Updated WP_HOME and WP_SITEURL in $FILE"
  done
}








nginx_br() {

	local mode=$1

	if ! grep -q "kjlion/nginx:alpine" /home/web/docker-compose.yml; then
		wget -O /home/web/nginx.conf "${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/nginx10.conf"
	fi

	if [ "$mode" == "on" ]; then
		# 寮€鍚?Brotli锛氬幓鎺夋敞閲?
		sed -i 's|# load_module /etc/nginx/modules/ngx_http_brotli_filter_module.so;|load_module /etc/nginx/modules/ngx_http_brotli_filter_module.so;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|# load_module /etc/nginx/modules/ngx_http_brotli_static_module.so;|load_module /etc/nginx/modules/ngx_http_brotli_static_module.so;|' /home/web/nginx.conf > /dev/null 2>&1

		sed -i 's|^\(\s*\)# brotli on;|\1brotli on;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)# brotli_static on;|\1brotli_static on;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)# brotli_comp_level \(.*\);|\1brotli_comp_level \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)# brotli_buffers \(.*\);|\1brotli_buffers \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)# brotli_min_length \(.*\);|\1brotli_min_length \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)# brotli_window \(.*\);|\1brotli_window \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)# brotli_types \(.*\);|\1brotli_types \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i '/brotli_types/,+6 s/^\(\s*\)#\s*/\1/' /home/web/nginx.conf

	elif [ "$mode" == "off" ]; then
		# 鍏抽棴 Brotli锛氬姞涓婃敞閲?
		sed -i 's|^load_module /etc/nginx/modules/ngx_http_brotli_filter_module.so;|# load_module /etc/nginx/modules/ngx_http_brotli_filter_module.so;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^load_module /etc/nginx/modules/ngx_http_brotli_static_module.so;|# load_module /etc/nginx/modules/ngx_http_brotli_static_module.so;|' /home/web/nginx.conf > /dev/null 2>&1

		sed -i 's|^\(\s*\)brotli on;|\1# brotli on;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)brotli_static on;|\1# brotli_static on;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)brotli_comp_level \(.*\);|\1# brotli_comp_level \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)brotli_buffers \(.*\);|\1# brotli_buffers \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)brotli_min_length \(.*\);|\1# brotli_min_length \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)brotli_window \(.*\);|\1# brotli_window \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)brotli_types \(.*\);|\1# brotli_types \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i '/brotli_types/,+6 {
			/^[[:space:]]*[^#[:space:]]/ s/^\(\s*\)/\1# /
		}' /home/web/nginx.conf

	else
		echo "鏃犳晥鐨勫弬鏁帮細浣跨敤 'on' 鎴?'off'"
		return 1
	fi

	# 妫€鏌?nginx 闀滃儚骞舵牴鎹儏鍐靛鐞?
	if grep -q "kjlion/nginx:alpine" /home/web/docker-compose.yml; then
		docker exec nginx nginx -s reload
	else
		sed -i 's|nginx:alpine|kjlion/nginx:alpine|g' /home/web/docker-compose.yml
		nginx_upgrade
	fi


}



nginx_zstd() {

	local mode=$1

	if ! grep -q "kjlion/nginx:alpine" /home/web/docker-compose.yml; then
		wget -O /home/web/nginx.conf "${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/nginx10.conf"
	fi

	if [ "$mode" == "on" ]; then
		# 寮€鍚?Zstd锛氬幓鎺夋敞閲?
		sed -i 's|# load_module /etc/nginx/modules/ngx_http_zstd_filter_module.so;|load_module /etc/nginx/modules/ngx_http_zstd_filter_module.so;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|# load_module /etc/nginx/modules/ngx_http_zstd_static_module.so;|load_module /etc/nginx/modules/ngx_http_zstd_static_module.so;|' /home/web/nginx.conf > /dev/null 2>&1

		sed -i 's|^\(\s*\)# zstd on;|\1zstd on;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)# zstd_static on;|\1zstd_static on;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)# zstd_comp_level \(.*\);|\1zstd_comp_level \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)# zstd_buffers \(.*\);|\1zstd_buffers \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)# zstd_min_length \(.*\);|\1zstd_min_length \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)# zstd_types \(.*\);|\1zstd_types \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i '/zstd_types/,+6 s/^\(\s*\)#\s*/\1/' /home/web/nginx.conf



	elif [ "$mode" == "off" ]; then
		# 鍏抽棴 Zstd锛氬姞涓婃敞閲?
		sed -i 's|^load_module /etc/nginx/modules/ngx_http_zstd_filter_module.so;|# load_module /etc/nginx/modules/ngx_http_zstd_filter_module.so;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^load_module /etc/nginx/modules/ngx_http_zstd_static_module.so;|# load_module /etc/nginx/modules/ngx_http_zstd_static_module.so;|' /home/web/nginx.conf > /dev/null 2>&1

		sed -i 's|^\(\s*\)zstd on;|\1# zstd on;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)zstd_static on;|\1# zstd_static on;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)zstd_comp_level \(.*\);|\1# zstd_comp_level \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)zstd_buffers \(.*\);|\1# zstd_buffers \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)zstd_min_length \(.*\);|\1# zstd_min_length \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i 's|^\(\s*\)zstd_types \(.*\);|\1# zstd_types \2;|' /home/web/nginx.conf > /dev/null 2>&1
		sed -i '/zstd_types/,+6 {
			/^[[:space:]]*[^#[:space:]]/ s/^\(\s*\)/\1# /
		}' /home/web/nginx.conf


	else
		echo "鏃犳晥鐨勫弬鏁帮細浣跨敤 'on' 鎴?'off'"
		return 1
	fi

	# 妫€鏌?nginx 闀滃儚骞舵牴鎹儏鍐靛鐞?
	if grep -q "kjlion/nginx:alpine" /home/web/docker-compose.yml; then
		docker exec nginx nginx -s reload
	else
		sed -i 's|nginx:alpine|kjlion/nginx:alpine|g' /home/web/docker-compose.yml
		nginx_upgrade
	fi



}








nginx_gzip() {

	local mode=$1
	if [ "$mode" == "on" ]; then
		sed -i 's|^\(\s*\)# gzip on;|\1gzip on;|' /home/web/nginx.conf > /dev/null 2>&1
	elif [ "$mode" == "off" ]; then
		sed -i 's|^\(\s*\)gzip on;|\1# gzip on;|' /home/web/nginx.conf > /dev/null 2>&1
	else
		echo "鏃犳晥鐨勫弬鏁帮細浣跨敤 'on' 鎴?'off'"
		return 1
	fi

	docker exec nginx nginx -s reload

}






web_security() {
	  send_stats "LDNMP鐜闃插尽"
	  while true; do
		check_f2b_status
		check_waf_status
		check_cf_mode
			  clear
			  echo -e "鏈嶅姟鍣ㄧ綉绔欓槻寰＄▼搴?${check_f2b_status}${gl_lv}${CFmessage}${waf_status}${gl_bai}"
			  echo "------------------------"
			  echo "1. 瀹夎闃插尽绋嬪簭"
			  echo "------------------------"
			  echo "5. 鏌ョ湅SSH鎷︽埅璁板綍                6. 鏌ョ湅缃戠珯鎷︽埅璁板綍"
			  echo "7. 鏌ョ湅闃插尽瑙勫垯鍒楄〃               8. 鏌ョ湅鏃ュ織瀹炴椂鐩戞帶"
			  echo "------------------------"
			  echo "11. 閰嶇疆鎷︽埅鍙傛暟                  12. 娓呴櫎鎵€鏈夋媺榛戠殑IP"
			  echo "------------------------"
			  echo "21. cloudflare妯″紡                22. 楂樿礋杞藉紑鍚?绉掔浘"
			  echo "------------------------"
			  echo "31. 寮€鍚疻AF                       32. 鍏抽棴WAF"
			  echo "33. 寮€鍚疍DOS闃插尽                  34. 鍏抽棴DDOS闃插尽"
			  echo "------------------------"
			  echo "9. 鍗歌浇闃插尽绋嬪簭"
			  echo "------------------------"
			  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
			  echo "------------------------"
			  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice
			  case $sub_choice in
				  1)
					  f2b_install_sshd
					  cd /etc/fail2ban/filter.d
					  curl -sS -O ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/fail2ban-nginx-cc.conf
					  wget ${gh_proxy}raw.githubusercontent.com/linuxserver/fail2ban-confs/master/filter.d/nginx-418.conf
					  wget ${gh_proxy}raw.githubusercontent.com/linuxserver/fail2ban-confs/master/filter.d/nginx-deny.conf
					  wget ${gh_proxy}raw.githubusercontent.com/linuxserver/fail2ban-confs/master/filter.d/nginx-unauthorized.conf
					  wget ${gh_proxy}raw.githubusercontent.com/linuxserver/fail2ban-confs/master/filter.d/nginx-bad-request.conf

					  cd /etc/fail2ban/jail.d/
					  curl -sS -O ${gh_proxy}raw.githubusercontent.com/kejilion/config/main/fail2ban/nginx-docker-cc.conf
					  sed -i "/cloudflare/d" /etc/fail2ban/jail.d/nginx-docker-cc.conf
					  f2b_status
					  ;;
				  5)
					  echo "------------------------"
					  f2b_sshd
					  echo "------------------------"
					  ;;
				  6)

					  echo "------------------------"
					  local xxx="fail2ban-nginx-cc"
					  f2b_status_xxx
					  echo "------------------------"
					  local xxx="nginx-418"
					  f2b_status_xxx
					  echo "------------------------"
					  local xxx="nginx-bad-request"
					  f2b_status_xxx
					  echo "------------------------"
					  local xxx="nginx-badbots"
					  f2b_status_xxx
					  echo "------------------------"
					  local xxx="nginx-botsearch"
					  f2b_status_xxx
					  echo "------------------------"
					  local xxx="nginx-deny"
					  f2b_status_xxx
					  echo "------------------------"
					  local xxx="nginx-http-auth"
					  f2b_status_xxx
					  echo "------------------------"
					  local xxx="nginx-unauthorized"
					  f2b_status_xxx
					  echo "------------------------"
					  local xxx="php-url-fopen"
					  f2b_status_xxx
					  echo "------------------------"

					  ;;

				  7)
					  fail2ban-client status
					  ;;
				  8)
					  tail -f /var/log/fail2ban.log

					  ;;
				  9)
					  remove fail2ban
					  rm -rf /etc/fail2ban
					  crontab -l | grep -v "CF-Under-Attack.sh" | crontab - 2>/dev/null
					  echo "Fail2Ban闃插尽绋嬪簭宸插嵏杞?
					  break
					  ;;

				  11)
					  install nano
					  nano /etc/fail2ban/jail.d/nginx-docker-cc.conf
					  f2b_status
					  break
					  ;;

				  12)
					  fail2ban-client unban --all
					  ;;

				  21)
					  send_stats "cloudflare妯″紡"
					  echo "鍒癱f鍚庡彴鍙充笂瑙掓垜鐨勪釜浜鸿祫鏂欙紝閫夋嫨宸︿晶API浠ょ墝锛岃幏鍙朑lobal API Key"
					  echo "https://dash.cloudflare.com/login"
					  read -e -p "杈撳叆CF鐨勮处鍙? " cfuser
					  read -e -p "杈撳叆CF鐨凣lobal API Key: " cftoken

					  wget -O /home/web/conf.d/default.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/default11.conf
					  docker exec nginx nginx -s reload

					  cd /etc/fail2ban/jail.d/
					  curl -sS -O ${gh_proxy}raw.githubusercontent.com/kejilion/config/main/fail2ban/nginx-docker-cc.conf

					  cd /etc/fail2ban/action.d
					  curl -sS -O ${gh_proxy}raw.githubusercontent.com/kejilion/config/main/fail2ban/cloudflare-docker.conf

					  sed -i "s/kejilion@outlook.com/$cfuser/g" /etc/fail2ban/action.d/cloudflare-docker.conf
					  sed -i "s/APIKEY00000/$cftoken/g" /etc/fail2ban/action.d/cloudflare-docker.conf
					  f2b_status

					  echo "宸查厤缃甤loudflare妯″紡锛屽彲鍦╟f鍚庡彴锛岀珯鐐?瀹夊叏鎬?浜嬩欢涓煡鐪嬫嫤鎴褰?
					  ;;

				  22)
					  send_stats "楂樿礋杞藉紑鍚?绉掔浘"
					  echo -e "${gl_huang}缃戠珯姣?鍒嗛挓鑷姩妫€娴嬶紝褰撹揪妫€娴嬪埌楂樿礋杞戒細鑷姩寮€鐩撅紝浣庤礋杞戒篃浼氳嚜鍔ㄥ叧闂?绉掔浘銆?{gl_bai}"
					  echo "--------------"
					  echo "鑾峰彇CF鍙傛暟: "
					  echo -e "鍒癱f鍚庡彴鍙充笂瑙掓垜鐨勪釜浜鸿祫鏂欙紝閫夋嫨宸︿晶API浠ょ墝锛岃幏鍙?{gl_huang}Global API Key${gl_bai}"
					  echo -e "鍒癱f鍚庡彴鍩熷悕姒傝椤甸潰鍙充笅鏂硅幏鍙?{gl_huang}鍖哄煙ID${gl_bai}"
					  echo "https://dash.cloudflare.com/login"
					  echo "--------------"
					  read -e -p "杈撳叆CF鐨勮处鍙? " cfuser
					  read -e -p "杈撳叆CF鐨凣lobal API Key: " cftoken
					  read -e -p "杈撳叆CF涓煙鍚嶇殑鍖哄煙ID: " cfzonID

					  cd ~
					  install jq bc
					  check_crontab_installed
					  curl -sS -O ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/CF-Under-Attack.sh
					  chmod +x CF-Under-Attack.sh
					  sed -i "s/AAAA/$cfuser/g" ~/CF-Under-Attack.sh
					  sed -i "s/BBBB/$cftoken/g" ~/CF-Under-Attack.sh
					  sed -i "s/CCCC/$cfzonID/g" ~/CF-Under-Attack.sh

					  local cron_job="*/5 * * * * ~/CF-Under-Attack.sh"

					  local existing_cron=$(crontab -l 2>/dev/null | grep -F "$cron_job")

					  if [ -z "$existing_cron" ]; then
						  (crontab -l 2>/dev/null; echo "$cron_job") | crontab -
						  echo "楂樿礋杞借嚜鍔ㄥ紑鐩捐剼鏈凡娣诲姞"
					  else
						  echo "鑷姩寮€鐩捐剼鏈凡瀛樺湪锛屾棤闇€娣诲姞"
					  fi

					  ;;

				  31)
					  nginx_waf on
					  echo "绔欑偣WAF宸插紑鍚?
					  send_stats "绔欑偣WAF宸插紑鍚?
					  ;;

				  32)
				  	  nginx_waf off
					  echo "绔欑偣WAF宸插叧闂?
					  send_stats "绔欑偣WAF宸插叧闂?
					  ;;

				  33)
					  enable_ddos_defense
					  ;;

				  34)
					  disable_ddos_defense
					  ;;

				  *)
					  break
					  ;;
			  esac
	  break_end
	  done
}



check_ldnmp_mode() {

	local MYSQL_CONTAINER="mysql"
	local MYSQL_CONF="/etc/mysql/conf.d/custom_mysql_config.cnf"

	# 妫€鏌?MySQL 閰嶇疆鏂囦欢涓槸鍚﹀寘鍚?4096M
	if docker exec "$MYSQL_CONTAINER" grep -q "4096M" "$MYSQL_CONF" 2>/dev/null; then
		mode_info=" 楂樻€ц兘妯″紡"
	else
		mode_info=" 鏍囧噯妯″紡"
	fi



}


check_nginx_compression() {

	local CONFIG_FILE="/home/web/nginx.conf"

	# 妫€鏌?zstd 鏄惁寮€鍚笖鏈娉ㄩ噴锛堟暣琛屼互 zstd on; 寮€澶达級
	if grep -qE '^\s*zstd\s+on;' "$CONFIG_FILE"; then
		zstd_status=" zstd鍘嬬缉宸插紑鍚?
	else
		zstd_status=""
	fi

	# 妫€鏌?brotli 鏄惁寮€鍚笖鏈娉ㄩ噴
	if grep -qE '^\s*brotli\s+on;' "$CONFIG_FILE"; then
		br_status=" br鍘嬬缉宸插紑鍚?
	else
		br_status=""
	fi

	# 妫€鏌?gzip 鏄惁寮€鍚笖鏈娉ㄩ噴
	if grep -qE '^\s*gzip\s+on;' "$CONFIG_FILE"; then
		gzip_status=" gzip鍘嬬缉宸插紑鍚?
	else
		gzip_status=""
	fi
}




web_optimization() {
		  while true; do
		  	  check_ldnmp_mode
			  check_nginx_compression
			  clear
			  send_stats "浼樺寲LDNMP鐜"
			  echo -e "浼樺寲LDNMP鐜${gl_lv}${mode_info}${gzip_status}${br_status}${zstd_status}${gl_bai}"
			  echo "------------------------"
			  echo "1. 鏍囧噯妯″紡              2. 楂樻€ц兘妯″紡 (鎺ㄨ崘2H4G浠ヤ笂)"
			  echo "------------------------"
			  echo "3. 寮€鍚痝zip鍘嬬缉          4. 鍏抽棴gzip鍘嬬缉"
			  echo "5. 寮€鍚痓r鍘嬬缉            6. 鍏抽棴br鍘嬬缉"
			  echo "7. 寮€鍚痾std鍘嬬缉          8. 鍏抽棴zstd鍘嬬缉"
			  echo "------------------------"
			  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
			  echo "------------------------"
			  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice
			  case $sub_choice in
				  1)
				  send_stats "绔欑偣鏍囧噯妯″紡"

				  local cpu_cores=$(nproc)
				  local connections=$((1024 * ${cpu_cores}))
				  sed -i "s/worker_processes.*/worker_processes ${cpu_cores};/" /home/web/nginx.conf
				  sed -i "s/worker_connections.*/worker_connections ${connections};/" /home/web/nginx.conf


				  # php璋冧紭
				  wget -O /home/optimized_php.ini ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/optimized_php.ini
				  docker cp /home/optimized_php.ini php:/usr/local/etc/php/conf.d/optimized_php.ini
				  docker cp /home/optimized_php.ini php74:/usr/local/etc/php/conf.d/optimized_php.ini
				  rm -rf /home/optimized_php.ini

				  # php璋冧紭
				  wget -O /home/www.conf ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/www-1.conf
				  docker cp /home/www.conf php:/usr/local/etc/php-fpm.d/www.conf
				  docker cp /home/www.conf php74:/usr/local/etc/php-fpm.d/www.conf
				  rm -rf /home/www.conf

				  patch_wp_memory_limit
				  patch_wp_debug

				  fix_phpfpm_conf php
				  fix_phpfpm_conf php74

				  # mysql璋冧紭
				  wget -O /home/custom_mysql_config.cnf ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/custom_mysql_config-1.cnf
				  docker cp /home/custom_mysql_config.cnf mysql:/etc/mysql/conf.d/
				  rm -rf /home/custom_mysql_config.cnf


				  cd /home/web && docker compose restart

				  optimize_balanced


				  echo "LDNMP鐜宸茶缃垚 鏍囧噯妯″紡"

					  ;;
				  2)
				  send_stats "绔欑偣楂樻€ц兘妯″紡"

				  # nginx璋冧紭
				  local cpu_cores=$(nproc)
				  local connections=$((2048 * ${cpu_cores}))
				  sed -i "s/worker_processes.*/worker_processes ${cpu_cores};/" /home/web/nginx.conf
				  sed -i "s/worker_connections.*/worker_connections ${connections};/" /home/web/nginx.conf

				  # php璋冧紭
				  wget -O /home/optimized_php.ini ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/optimized_php.ini
				  docker cp /home/optimized_php.ini php:/usr/local/etc/php/conf.d/optimized_php.ini
				  docker cp /home/optimized_php.ini php74:/usr/local/etc/php/conf.d/optimized_php.ini
				  rm -rf /home/optimized_php.ini

				  # php璋冧紭
				  wget -O /home/www.conf ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/www.conf
				  docker cp /home/www.conf php:/usr/local/etc/php-fpm.d/www.conf
				  docker cp /home/www.conf php74:/usr/local/etc/php-fpm.d/www.conf
				  rm -rf /home/www.conf

				  patch_wp_memory_limit 512M 512M
				  patch_wp_debug

				  fix_phpfpm_conf php
				  fix_phpfpm_conf php74

				  # mysql璋冧紭
				  wget -O /home/custom_mysql_config.cnf ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/custom_mysql_config.cnf
				  docker cp /home/custom_mysql_config.cnf mysql:/etc/mysql/conf.d/
				  rm -rf /home/custom_mysql_config.cnf

				  cd /home/web && docker compose restart

				  optimize_web_server

				  echo "LDNMP鐜宸茶缃垚 楂樻€ц兘妯″紡"

					  ;;
				  3)
				  send_stats "nginx_gzip on"
				  nginx_gzip on
					  ;;
				  4)
				  send_stats "nginx_gzip off"
				  nginx_gzip off
					  ;;
				  5)
				  send_stats "nginx_br on"
				  nginx_br on
					  ;;
				  6)
				  send_stats "nginx_br off"
				  nginx_br off
					  ;;
				  7)
				  send_stats "nginx_zstd on"
				  nginx_zstd on
					  ;;
				  8)
				  send_stats "nginx_zstd off"
				  nginx_zstd off
					  ;;
				  *)
					  break
					  ;;
			  esac
			  break_end

		  done


}










check_docker_app() {
	if docker ps -a --format '{{.Names}}' 2>/dev/null | grep -q "$docker_name" ; then
		check_docker="${gl_lv}宸插畨瑁?{gl_bai}"
	else
		check_docker="${gl_hui}鏈畨瑁?{gl_bai}"
	fi
}



# check_docker_app() {

# if docker ps -a --format '{{.Names}}' 2>/dev/null | grep -q "$docker_name"; then
# 	check_docker="${gl_lv}宸插畨瑁?{gl_bai}"
# else
# 	check_docker="${gl_hui}鏈畨瑁?{gl_bai}"
# fi

# }


check_docker_app_ip() {
echo "------------------------"
echo "璁块棶鍦板潃:"
ip_address



if [ -n "$ipv4_address" ]; then
	echo "http://$ipv4_address:${docker_port}"
fi

if [ -n "$ipv6_address" ]; then
	echo "http://[$ipv6_address]:${docker_port}"
fi

local search_pattern1="$ipv4_address:${docker_port}"
local search_pattern2="127.0.0.1:${docker_port}"

for file in /home/web/conf.d/*; do
	if [ -f "$file" ]; then
		if grep -q "$search_pattern1" "$file" 2>/dev/null || grep -q "$search_pattern2" "$file" 2>/dev/null; then
			echo "https://$(basename "$file" | sed 's/\.conf$//')"
		fi
	fi
done


}


check_docker_image_update() {
	local container_name=$1
	update_status=""

	# 1. 鍖哄煙妫€鏌?
	local country=$(curl -s --max-time 2 ipinfo.io/country)
	[[ "$country" == "CN" ]] && return

	# 2. 鑾峰彇鏈湴闀滃儚淇℃伅
	local container_info=$(docker inspect --format='{{.Created}},{{.Config.Image}}' "$container_name" 2>/dev/null)
	[[ -z "$container_info" ]] && return

	local container_created=$(echo "$container_info" | cut -d',' -f1)
	local full_image_name=$(echo "$container_info" | cut -d',' -f2)
	local container_created_ts=$(date -d "$container_created" +%s 2>/dev/null)

	# 3. 鏅鸿兘璺敱鍒ゆ柇
	if [[ "$full_image_name" == ghcr.io* ]]; then
		# --- 鍦烘櫙 A: 闀滃儚鍦?GitHub (ghcr.io) ---
		# 鎻愬彇浠撳簱璺緞锛屼緥濡?ghcr.io/onexru/oneimg -> onexru/oneimg
		local repo_path=$(echo "$full_image_name" | sed 's/ghcr.io\///' | cut -d':' -f1)
		# 娉ㄦ剰锛歡hcr.io 鐨?API 姣旇緝澶嶆潅锛岄€氬父鏈€蹇殑鏂规硶鏄煡 GitHub Repo 鐨?Release
		local api_url="https://api.github.com/repos/$repo_path/releases/latest"
		local remote_date=$(curl -s "$api_url" | jq -r '.published_at' 2>/dev/null)

	elif [[ "$full_image_name" == *"oneimg"* ]]; then
		# --- 鍦烘櫙 B: 鐗规畩鎸囧畾 (鍗充究鍦?Docker Hub锛屼篃鎯抽€氳繃 GitHub Release 鍒ゆ柇) ---
		local api_url="https://api.github.com/repos/onexru/oneimg/releases/latest"
		local remote_date=$(curl -s "$api_url" | jq -r '.published_at' 2>/dev/null)

	else
		# --- 鍦烘櫙 C: 鏍囧噯 Docker Hub ---
		local image_repo=${full_image_name%%:*}
		local image_tag=${full_image_name##*:}
		[[ "$image_repo" == "$image_tag" ]] && image_tag="latest"
		[[ "$image_repo" != */* ]] && image_repo="library/$image_repo"

		local api_url="https://hub.docker.com/v2/repositories/$image_repo/tags/$image_tag"
		local remote_date=$(curl -s "$api_url" | jq -r '.last_updated' 2>/dev/null)
	fi

	# 4. 鏃堕棿鎴冲姣?
	if [[ -n "$remote_date" && "$remote_date" != "null" ]]; then
		local remote_ts=$(date -d "$remote_date" +%s 2>/dev/null)
		if [[ $container_created_ts -lt $remote_ts ]]; then
			update_status="${gl_huang}鍙戠幇鏂扮増鏈?${gl_bai}"
		fi
	fi
}







block_container_port() {
	local container_name_or_id=$1
	local allowed_ip=$2

	# 鑾峰彇瀹瑰櫒鐨?IP 鍦板潃
	local container_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container_name_or_id")

	if [ -z "$container_ip" ]; then
		return 1
	fi

	install iptables


	# 妫€鏌ュ苟灏佺鍏朵粬鎵€鏈?IP
	if ! iptables -C DOCKER-USER -p tcp -d "$container_ip" -j DROP &>/dev/null; then
		iptables -I DOCKER-USER -p tcp -d "$container_ip" -j DROP
	fi

	# 妫€鏌ュ苟鏀捐鎸囧畾 IP
	if ! iptables -C DOCKER-USER -p tcp -s "$allowed_ip" -d "$container_ip" -j ACCEPT &>/dev/null; then
		iptables -I DOCKER-USER -p tcp -s "$allowed_ip" -d "$container_ip" -j ACCEPT
	fi

	# 妫€鏌ュ苟鏀捐鏈湴缃戠粶 127.0.0.0/8
	if ! iptables -C DOCKER-USER -p tcp -s 127.0.0.0/8 -d "$container_ip" -j ACCEPT &>/dev/null; then
		iptables -I DOCKER-USER -p tcp -s 127.0.0.0/8 -d "$container_ip" -j ACCEPT
	fi



	# 妫€鏌ュ苟灏佺鍏朵粬鎵€鏈?IP
	if ! iptables -C DOCKER-USER -p udp -d "$container_ip" -j DROP &>/dev/null; then
		iptables -I DOCKER-USER -p udp -d "$container_ip" -j DROP
	fi

	# 妫€鏌ュ苟鏀捐鎸囧畾 IP
	if ! iptables -C DOCKER-USER -p udp -s "$allowed_ip" -d "$container_ip" -j ACCEPT &>/dev/null; then
		iptables -I DOCKER-USER -p udp -s "$allowed_ip" -d "$container_ip" -j ACCEPT
	fi

	# 妫€鏌ュ苟鏀捐鏈湴缃戠粶 127.0.0.0/8
	if ! iptables -C DOCKER-USER -p udp -s 127.0.0.0/8 -d "$container_ip" -j ACCEPT &>/dev/null; then
		iptables -I DOCKER-USER -p udp -s 127.0.0.0/8 -d "$container_ip" -j ACCEPT
	fi

	if ! iptables -C DOCKER-USER -m state --state ESTABLISHED,RELATED -d "$container_ip" -j ACCEPT &>/dev/null; then
		iptables -I DOCKER-USER -m state --state ESTABLISHED,RELATED -d "$container_ip" -j ACCEPT
	fi


	echo "宸查樆姝P+绔彛璁块棶璇ユ湇鍔?
	save_iptables_rules
}




clear_container_rules() {
	local container_name_or_id=$1
	local allowed_ip=$2

	# 鑾峰彇瀹瑰櫒鐨?IP 鍦板潃
	local container_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container_name_or_id")

	if [ -z "$container_ip" ]; then
		return 1
	fi

	install iptables


	# 娓呴櫎灏佺鍏朵粬鎵€鏈?IP 鐨勮鍒?
	if iptables -C DOCKER-USER -p tcp -d "$container_ip" -j DROP &>/dev/null; then
		iptables -D DOCKER-USER -p tcp -d "$container_ip" -j DROP
	fi

	# 娓呴櫎鏀捐鎸囧畾 IP 鐨勮鍒?
	if iptables -C DOCKER-USER -p tcp -s "$allowed_ip" -d "$container_ip" -j ACCEPT &>/dev/null; then
		iptables -D DOCKER-USER -p tcp -s "$allowed_ip" -d "$container_ip" -j ACCEPT
	fi

	# 娓呴櫎鏀捐鏈湴缃戠粶 127.0.0.0/8 鐨勮鍒?
	if iptables -C DOCKER-USER -p tcp -s 127.0.0.0/8 -d "$container_ip" -j ACCEPT &>/dev/null; then
		iptables -D DOCKER-USER -p tcp -s 127.0.0.0/8 -d "$container_ip" -j ACCEPT
	fi





	# 娓呴櫎灏佺鍏朵粬鎵€鏈?IP 鐨勮鍒?
	if iptables -C DOCKER-USER -p udp -d "$container_ip" -j DROP &>/dev/null; then
		iptables -D DOCKER-USER -p udp -d "$container_ip" -j DROP
	fi

	# 娓呴櫎鏀捐鎸囧畾 IP 鐨勮鍒?
	if iptables -C DOCKER-USER -p udp -s "$allowed_ip" -d "$container_ip" -j ACCEPT &>/dev/null; then
		iptables -D DOCKER-USER -p udp -s "$allowed_ip" -d "$container_ip" -j ACCEPT
	fi

	# 娓呴櫎鏀捐鏈湴缃戠粶 127.0.0.0/8 鐨勮鍒?
	if iptables -C DOCKER-USER -p udp -s 127.0.0.0/8 -d "$container_ip" -j ACCEPT &>/dev/null; then
		iptables -D DOCKER-USER -p udp -s 127.0.0.0/8 -d "$container_ip" -j ACCEPT
	fi


	if iptables -C DOCKER-USER -m state --state ESTABLISHED,RELATED -d "$container_ip" -j ACCEPT &>/dev/null; then
		iptables -D DOCKER-USER -m state --state ESTABLISHED,RELATED -d "$container_ip" -j ACCEPT
	fi


	echo "宸插厑璁窱P+绔彛璁块棶璇ユ湇鍔?
	save_iptables_rules
}






block_host_port() {
	local port=$1
	local allowed_ip=$2

	if [[ -z "$port" || -z "$allowed_ip" ]]; then
		echo "閿欒锛氳鎻愪緵绔彛鍙峰拰鍏佽璁块棶鐨?IP銆?
		echo "鐢ㄦ硶: block_host_port <绔彛鍙? <鍏佽鐨処P>"
		return 1
	fi

	install iptables


	# 鎷掔粷鍏朵粬鎵€鏈?IP 璁块棶
	if ! iptables -C INPUT -p tcp --dport "$port" -j DROP &>/dev/null; then
		iptables -I INPUT -p tcp --dport "$port" -j DROP
	fi

	# 鍏佽鎸囧畾 IP 璁块棶
	if ! iptables -C INPUT -p tcp --dport "$port" -s "$allowed_ip" -j ACCEPT &>/dev/null; then
		iptables -I INPUT -p tcp --dport "$port" -s "$allowed_ip" -j ACCEPT
	fi

	# 鍏佽鏈満璁块棶
	if ! iptables -C INPUT -p tcp --dport "$port" -s 127.0.0.0/8 -j ACCEPT &>/dev/null; then
		iptables -I INPUT -p tcp --dport "$port" -s 127.0.0.0/8 -j ACCEPT
	fi





	# 鎷掔粷鍏朵粬鎵€鏈?IP 璁块棶
	if ! iptables -C INPUT -p udp --dport "$port" -j DROP &>/dev/null; then
		iptables -I INPUT -p udp --dport "$port" -j DROP
	fi

	# 鍏佽鎸囧畾 IP 璁块棶
	if ! iptables -C INPUT -p udp --dport "$port" -s "$allowed_ip" -j ACCEPT &>/dev/null; then
		iptables -I INPUT -p udp --dport "$port" -s "$allowed_ip" -j ACCEPT
	fi

	# 鍏佽鏈満璁块棶
	if ! iptables -C INPUT -p udp --dport "$port" -s 127.0.0.0/8 -j ACCEPT &>/dev/null; then
		iptables -I INPUT -p udp --dport "$port" -s 127.0.0.0/8 -j ACCEPT
	fi

	# 鍏佽宸插缓绔嬪拰鐩稿叧杩炴帴鐨勬祦閲?
	if ! iptables -C INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT &>/dev/null; then
		iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	fi

	echo "宸查樆姝P+绔彛璁块棶璇ユ湇鍔?
	save_iptables_rules
}




clear_host_port_rules() {
	local port=$1
	local allowed_ip=$2

	if [[ -z "$port" || -z "$allowed_ip" ]]; then
		echo "閿欒锛氳鎻愪緵绔彛鍙峰拰鍏佽璁块棶鐨?IP銆?
		echo "鐢ㄦ硶: clear_host_port_rules <绔彛鍙? <鍏佽鐨処P>"
		return 1
	fi

	install iptables


	# 娓呴櫎灏佺鎵€鏈夊叾浠?IP 璁块棶鐨勮鍒?
	if iptables -C INPUT -p tcp --dport "$port" -j DROP &>/dev/null; then
		iptables -D INPUT -p tcp --dport "$port" -j DROP
	fi

	# 娓呴櫎鍏佽鏈満璁块棶鐨勮鍒?
	if iptables -C INPUT -p tcp --dport "$port" -s 127.0.0.0/8 -j ACCEPT &>/dev/null; then
		iptables -D INPUT -p tcp --dport "$port" -s 127.0.0.0/8 -j ACCEPT
	fi

	# 娓呴櫎鍏佽鎸囧畾 IP 璁块棶鐨勮鍒?
	if iptables -C INPUT -p tcp --dport "$port" -s "$allowed_ip" -j ACCEPT &>/dev/null; then
		iptables -D INPUT -p tcp --dport "$port" -s "$allowed_ip" -j ACCEPT
	fi


	# 娓呴櫎灏佺鎵€鏈夊叾浠?IP 璁块棶鐨勮鍒?
	if iptables -C INPUT -p udp --dport "$port" -j DROP &>/dev/null; then
		iptables -D INPUT -p udp --dport "$port" -j DROP
	fi

	# 娓呴櫎鍏佽鏈満璁块棶鐨勮鍒?
	if iptables -C INPUT -p udp --dport "$port" -s 127.0.0.0/8 -j ACCEPT &>/dev/null; then
		iptables -D INPUT -p udp --dport "$port" -s 127.0.0.0/8 -j ACCEPT
	fi

	# 娓呴櫎鍏佽鎸囧畾 IP 璁块棶鐨勮鍒?
	if iptables -C INPUT -p udp --dport "$port" -s "$allowed_ip" -j ACCEPT &>/dev/null; then
		iptables -D INPUT -p udp --dport "$port" -s "$allowed_ip" -j ACCEPT
	fi


	echo "宸插厑璁窱P+绔彛璁块棶璇ユ湇鍔?
	save_iptables_rules

}



setup_docker_dir() {

	mkdir -p /home /home/docker 2>/dev/null

	if [ -d "/vol1/1000/" ] && [ ! -d "/vol1/1000/docker" ]; then
		cp -f /home/docker /home/docker1 2>/dev/null
		rm -rf /home/docker 2>/dev/null
		mkdir -p /vol1/1000/docker 2>/dev/null
		ln -s /vol1/1000/docker /home/docker 2>/dev/null
	fi

	if [ -d "/volume1/" ] && [ ! -d "/volume1/docker" ]; then
		cp -f /home/docker /home/docker1 2>/dev/null
		rm -rf /home/docker 2>/dev/null
		mkdir -p /volume1/docker 2>/dev/null
		ln -s /volume1/docker /home/docker 2>/dev/null
	fi


}


add_app_id() {
mkdir -p /home/docker
touch /home/docker/appno.txt
grep -qxF "${app_id}" /home/docker/appno.txt || echo "${app_id}" >> /home/docker/appno.txt

}



docker_app() {
send_stats "${docker_name}绠＄悊"

while true; do
	clear
	check_docker_app
	check_docker_image_update $docker_name
	echo -e "$docker_name $check_docker $update_status"
	echo "$docker_describe"
	echo "$docker_url"
	if docker ps -a --format '{{.Names}}' 2>/dev/null | grep -q "$docker_name"; then
		if [ ! -f "/home/docker/${docker_name}_port.conf" ]; then
			local docker_port=$(docker port "$docker_name" | head -n1 | awk -F'[:]' '/->/ {print $NF; exit}')
			docker_port=${docker_port:-0000}
			echo "$docker_port" > "/home/docker/${docker_name}_port.conf"
		fi
		local docker_port=$(cat "/home/docker/${docker_name}_port.conf")
		check_docker_app_ip
	fi
	echo ""
	echo "------------------------"
	echo "1. 瀹夎              2. 鏇存柊            3. 鍗歌浇"
	echo "------------------------"
	echo "5. 娣诲姞鍩熷悕璁块棶      6. 鍒犻櫎鍩熷悕璁块棶"
	echo "7. 鍏佽IP+绔彛璁块棶   8. 闃绘IP+绔彛璁块棶"
	echo "------------------------"
	echo "0. 杩斿洖涓婁竴绾ч€夊崟"
	echo "------------------------"
	read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " choice
	 case $choice in
		1)
			setup_docker_dir
			check_disk_space $app_size /home/docker
			while true; do
				read -e -p "杈撳叆搴旂敤瀵瑰鏈嶅姟绔彛锛屽洖杞﹂粯璁や娇鐢?{docker_port}绔彛: " app_port
				local app_port=${app_port:-${docker_port}}

				if ss -tuln | grep -q ":$app_port "; then
					echo -e "${gl_hong}閿欒: ${gl_bai}绔彛 $app_port 宸茶鍗犵敤锛岃鏇存崲涓€涓鍙?
					send_stats "搴旂敤绔彛宸茶鍗犵敤"
				else
					local docker_port=$app_port
					break
				fi
			done

			install jq
			install_docker
			docker_rum
			echo "$docker_port" > "/home/docker/${docker_name}_port.conf"

			add_app_id

			clear
			echo "$docker_name 宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
			echo ""
			$docker_use
			$docker_passwd
			send_stats "瀹夎$docker_name"
			;;
		2)
			docker rm -f "$docker_name"
			docker rmi -f "$docker_img"
			docker_rum

			add_app_id

			clear
			echo "$docker_name 宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
			echo ""
			$docker_use
			$docker_passwd
			send_stats "鏇存柊$docker_name"
			;;
		3)
			docker rm -f "$docker_name"
			docker rmi -f "$docker_img"
			rm -rf "/home/docker/$docker_name"
			rm -f /home/docker/${docker_name}_port.conf

			sed -i "/\b${app_id}\b/d" /home/docker/appno.txt
			echo "搴旂敤宸插嵏杞?
			send_stats "鍗歌浇$docker_name"
			;;

		5)
			echo "${docker_name}鍩熷悕璁块棶璁剧疆"
			send_stats "${docker_name}鍩熷悕璁块棶璁剧疆"
			add_yuming
			ldnmp_Proxy ${yuming} 127.0.0.1 ${docker_port}
			block_container_port "$docker_name" "$ipv4_address"
			;;

		6)
			echo "鍩熷悕鏍煎紡 example.com 涓嶅甫https://"
			web_del
			;;

		7)
			send_stats "鍏佽IP璁块棶 ${docker_name}"
			clear_container_rules "$docker_name" "$ipv4_address"
			;;

		8)
			send_stats "闃绘IP璁块棶 ${docker_name}"
			block_container_port "$docker_name" "$ipv4_address"
			;;

		*)
			break
			;;
	 esac
	 break_end
done

}





docker_app_plus() {
	send_stats "$app_name"
	while true; do
		clear
		check_docker_app
		check_docker_image_update $docker_name
		echo -e "$app_name $check_docker $update_status"
		echo "$app_text"
		echo "$app_url"
		if docker ps -a --format '{{.Names}}' 2>/dev/null | grep -q "$docker_name"; then
			if [ ! -f "/home/docker/${docker_name}_port.conf" ]; then
				local docker_port=$(docker port "$docker_name" | head -n1 | awk -F'[:]' '/->/ {print $NF; exit}')
				docker_port=${docker_port:-0000}
				echo "$docker_port" > "/home/docker/${docker_name}_port.conf"
			fi
			local docker_port=$(cat "/home/docker/${docker_name}_port.conf")
			check_docker_app_ip
		fi
		echo ""
		echo "------------------------"
		echo "1. 瀹夎             2. 鏇存柊             3. 鍗歌浇"
		echo "------------------------"
		echo "5. 娣诲姞鍩熷悕璁块棶     6. 鍒犻櫎鍩熷悕璁块棶"
		echo "7. 鍏佽IP+绔彛璁块棶  8. 闃绘IP+绔彛璁块棶"
		echo "------------------------"
		echo "0. 杩斿洖涓婁竴绾ч€夊崟"
		echo "------------------------"
		read -e -p "杈撳叆浣犵殑閫夋嫨: " choice
		case $choice in
			1)
				setup_docker_dir
				check_disk_space $app_size /home/docker

				while true; do
					read -e -p "杈撳叆搴旂敤瀵瑰鏈嶅姟绔彛锛屽洖杞﹂粯璁や娇鐢?{docker_port}绔彛: " app_port
					local app_port=${app_port:-${docker_port}}

					if ss -tuln | grep -q ":$app_port "; then
						echo -e "${gl_hong}閿欒: ${gl_bai}绔彛 $app_port 宸茶鍗犵敤锛岃鏇存崲涓€涓鍙?
						send_stats "搴旂敤绔彛宸茶鍗犵敤"
					else
						local docker_port=$app_port
						break
					fi
				done

				install jq
				install_docker
				docker_app_install
				echo "$docker_port" > "/home/docker/${docker_name}_port.conf"

				add_app_id
				send_stats "$app_name 瀹夎"
				;;

			2)
				docker_app_update
				add_app_id
				send_stats "$app_name 鏇存柊"
				;;

			3)
				docker_app_uninstall
				rm -f /home/docker/${docker_name}_port.conf

				sed -i "/\b${app_id}\b/d" /home/docker/appno.txt
				send_stats "$app_name 鍗歌浇"
				;;

			5)
				echo "${docker_name}鍩熷悕璁块棶璁剧疆"
				send_stats "${docker_name}鍩熷悕璁块棶璁剧疆"
				add_yuming
				ldnmp_Proxy ${yuming} 127.0.0.1 ${docker_port}
				block_container_port "$docker_name" "$ipv4_address"

				;;
			6)
				echo "鍩熷悕鏍煎紡 example.com 涓嶅甫https://"
				web_del
				;;
			7)
				send_stats "鍏佽IP璁块棶 ${docker_name}"
				clear_container_rules "$docker_name" "$ipv4_address"
				;;
			8)
				send_stats "闃绘IP璁块棶 ${docker_name}"
				block_container_port "$docker_name" "$ipv4_address"
				;;
			*)
				break
				;;
		esac
		break_end
	done
}





prometheus_install() {

local PROMETHEUS_DIR="/home/docker/monitoring/prometheus"
local GRAFANA_DIR="/home/docker/monitoring/grafana"
local NETWORK_NAME="monitoring"

# Create necessary directories
mkdir -p $PROMETHEUS_DIR
mkdir -p $GRAFANA_DIR

# Set correct ownership for Grafana directory
chown -R 472:472 $GRAFANA_DIR

if [ ! -f "$PROMETHEUS_DIR/prometheus.yml" ]; then
	curl -o "$PROMETHEUS_DIR/prometheus.yml" ${gh_proxy}raw.githubusercontent.com/kejilion/config/refs/heads/main/prometheus/prometheus.yml
fi

# Create Docker network for monitoring
docker network create $NETWORK_NAME

# Run Node Exporter container
docker run -d \
  --name=node-exporter \
  --network $NETWORK_NAME \
  --restart=always \
  prom/node-exporter

# Run Prometheus container
docker run -d \
  --name prometheus \
  -v $PROMETHEUS_DIR/prometheus.yml:/etc/prometheus/prometheus.yml \
  -v $PROMETHEUS_DIR/data:/prometheus \
  --network $NETWORK_NAME \
  --restart=always \
  --user 0:0 \
  prom/prometheus:latest

# Run Grafana container
docker run -d \
  --name grafana \
  -p ${docker_port}:3000 \
  -v $GRAFANA_DIR:/var/lib/grafana \
  --network $NETWORK_NAME \
  --restart=always \
  grafana/grafana:latest

}




tmux_run() {
	# Check if the session already exists
	tmux has-session -t $SESSION_NAME 2>/dev/null
	# $? is a special variable that holds the exit status of the last executed command
	if [ $? != 0 ]; then
	  # Session doesn't exist, create a new one
	  tmux new -s $SESSION_NAME
	else
	  # Session exists, attach to it
	  tmux attach-session -t $SESSION_NAME
	fi
}


tmux_run_d() {

local base_name="tmuxd"
local tmuxd_ID=1

# 妫€鏌ヤ細璇濇槸鍚﹀瓨鍦ㄧ殑鍑芥暟
session_exists() {
  tmux has-session -t $1 2>/dev/null
}

# 寰幆鐩村埌鎵惧埌涓€涓笉瀛樺湪鐨勪細璇濆悕绉?
while session_exists "$base_name-$tmuxd_ID"; do
  local tmuxd_ID=$((tmuxd_ID + 1))
done

# 鍒涘缓鏂扮殑 tmux 浼氳瘽
tmux new -d -s "$base_name-$tmuxd_ID" "$tmuxd"


}



f2b_status() {
	 fail2ban-client reload
	 sleep 3
	 fail2ban-client status
}

f2b_status_xxx() {
	fail2ban-client status $xxx
}

check_f2b_status() {
	if command -v fail2ban-client >/dev/null 2>&1; then
		check_f2b_status="${gl_lv}宸插畨瑁?{gl_bai}"
	else
		check_f2b_status="${gl_hui}鏈畨瑁?{gl_bai}"
	fi
}

f2b_install_sshd() {

	docker rm -f fail2ban >/dev/null 2>&1
	install fail2ban
	start fail2ban
	enable fail2ban

	if command -v dnf &>/dev/null; then
		cd /etc/fail2ban/jail.d/
		curl -sS -O ${gh_proxy}raw.githubusercontent.com/kejilion/config/main/fail2ban/centos-ssh.conf
	fi

	if command -v apt &>/dev/null; then
		install rsyslog
		systemctl start rsyslog
		systemctl enable rsyslog
	fi

}

f2b_sshd() {
	if grep -q 'Alpine' /etc/issue; then
		xxx=alpine-sshd
		f2b_status_xxx
	else
		xxx=sshd
		f2b_status_xxx
	fi
}




server_reboot() {

	read -e -p "$(echo -e "${gl_huang}鎻愮ず: ${gl_bai}鐜板湪閲嶅惎鏈嶅姟鍣ㄥ悧锛?Y/N): ")" rboot
	case "$rboot" in
	  [Yy])
		echo "宸查噸鍚?
		reboot
		;;
	  *)
		echo "宸插彇娑?
		;;
	esac


}





output_status() {
	output=$(awk 'BEGIN { rx_total = 0; tx_total = 0 }
		$1 ~ /^(eth|ens|enp|eno)[0-9]+/ {
			rx_total += $2
			tx_total += $10
		}
		END {
			rx_units = "Bytes";
			tx_units = "Bytes";
			if (rx_total > 1024) { rx_total /= 1024; rx_units = "K"; }
			if (rx_total > 1024) { rx_total /= 1024; rx_units = "M"; }
			if (rx_total > 1024) { rx_total /= 1024; rx_units = "G"; }

			if (tx_total > 1024) { tx_total /= 1024; tx_units = "K"; }
			if (tx_total > 1024) { tx_total /= 1024; tx_units = "M"; }
			if (tx_total > 1024) { tx_total /= 1024; tx_units = "G"; }

			printf("%.2f%s %.2f%s\n", rx_total, rx_units, tx_total, tx_units);
		}' /proc/net/dev)

	rx=$(echo "$output" | awk '{print $1}')
	tx=$(echo "$output" | awk '{print $2}')

}




ldnmp_install_status_one() {

   if docker inspect "php" &>/dev/null; then
	clear
	send_stats "鏃犳硶鍐嶆瀹夎LDNMP鐜"
	echo -e "${gl_huang}鎻愮ず: ${gl_bai}寤虹珯鐜宸插畨瑁呫€傛棤闇€鍐嶆瀹夎锛?
	break_end
	linux_ldnmp
   fi

}


ldnmp_install_all() {
cd ~
send_stats "瀹夎LDNMP鐜"
root_use
clear
echo -e "${gl_huang}LDNMP鐜鏈畨瑁咃紝寮€濮嬪畨瑁匧DNMP鐜...${gl_bai}"
check_disk_space 3 /home
install_dependency
install_docker
install_certbot
install_ldnmp_conf
install_ldnmp

}


nginx_install_all() {
cd ~
send_stats "瀹夎nginx鐜"
root_use
clear
echo -e "${gl_huang}nginx鏈畨瑁咃紝寮€濮嬪畨瑁卬ginx鐜...${gl_bai}"
install_dependency
install_docker
install_certbot
install_ldnmp_conf
nginx_upgrade
clear
local nginx_version=$(docker exec nginx nginx -v 2>&1)
local nginx_version=$(echo "$nginx_version" | grep -oP "nginx/\K[0-9]+\.[0-9]+\.[0-9]+")
echo "nginx宸插畨瑁呭畬鎴?
echo -e "褰撳墠鐗堟湰: ${gl_huang}v$nginx_version${gl_bai}"
echo ""

}




ldnmp_install_status() {

	if ! docker inspect "php" &>/dev/null; then
		send_stats "璇峰厛瀹夎LDNMP鐜"
		ldnmp_install_all
	fi

}


nginx_install_status() {

	if ! docker inspect "nginx" &>/dev/null; then
		send_stats "璇峰厛瀹夎nginx鐜"
		nginx_install_all
	fi

}




ldnmp_web_on() {
	  clear
	  echo "鎮ㄧ殑 $webname 鎼缓濂戒簡锛?
	  echo "https://$yuming"
	  echo "------------------------"
	  echo "$webname 瀹夎淇℃伅濡備笅: "

}

nginx_web_on() {
	clear

	local ipv4_pattern='^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'
	local ipv6_pattern='^(([0-9A-Fa-f]{1,4}:){1,7}:|([0-9A-Fa-f]{1,4}:){7,7}[0-9A-Fa-f]{1,4}|::1)$'

	echo "鎮ㄧ殑 $webname 鎼缓濂戒簡锛?

	if [[ "$yuming" =~ $ipv4_pattern || "$yuming" =~ $ipv6_pattern ]]; then
		mv /home/web/conf.d/"$yuming".conf /home/web/conf.d/"${yuming}_${access_port}".conf
		echo "http://$yuming:$access_port"
	elif grep -q '^[[:space:]]*#.*if (\$scheme = http)' "/home/web/conf.d/"$yuming".conf"; then
		echo "http://$yuming"
	else
		echo "https://$yuming"
	fi
}



ldnmp_wp() {
  clear
  # wordpress
  webname="WordPress"
  yuming="${1:-}"
  send_stats "瀹夎$webname"
  echo "寮€濮嬮儴缃?$webname"
  if [ -z "$yuming" ]; then
	add_yuming
  fi
  repeat_add_yuming
  ldnmp_install_status


  install_ssltls
  certs_status
  add_db

  wget -O /home/web/conf.d/map.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/map.conf
  wget -O /home/web/conf.d/$yuming.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/wordpress.com.conf
  sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf
  nginx_http_on


  cd /home/web/html
  mkdir $yuming
  cd $yuming
  wget -O latest.zip ${gh_proxy}github.com/kejilion/Website_source_code/raw/refs/heads/main/wp-latest.zip
  unzip latest.zip
  rm latest.zip
  echo "define('FS_METHOD', 'direct'); define('WP_REDIS_HOST', 'redis'); define('WP_REDIS_PORT', '6379'); define('WP_REDIS_MAXTTL', 86400); define('WP_CACHE_KEY_SALT', '${yuming}_');" >> /home/web/html/$yuming/wordpress/wp-config-sample.php
  sed -i "s|database_name_here|$dbname|g" /home/web/html/$yuming/wordpress/wp-config-sample.php
  sed -i "s|username_here|$dbuse|g" /home/web/html/$yuming/wordpress/wp-config-sample.php
  sed -i "s|password_here|$dbusepasswd|g" /home/web/html/$yuming/wordpress/wp-config-sample.php
  sed -i "s|localhost|mysql|g" /home/web/html/$yuming/wordpress/wp-config-sample.php
  patch_wp_url "https://$yuming" "https://$yuming"
  cp /home/web/html/$yuming/wordpress/wp-config-sample.php /home/web/html/$yuming/wordpress/wp-config.php


  restart_ldnmp
  nginx_web_on

}



ldnmp_Proxy() {
	clear
	webname="鍙嶅悜浠ｇ悊-IP+绔彛"
	yuming="${1:-}"
	reverseproxy="${2:-}"
	port="${3:-}"

	send_stats "瀹夎$webname"
	echo "寮€濮嬮儴缃?$webname"
	if [ -z "$yuming" ]; then
		add_yuming
	fi

	check_ip_and_get_access_port "$yuming"

	if [ -z "$reverseproxy" ]; then
		read -e -p "璇疯緭鍏ヤ綘鐨勫弽浠P (鍥炶溅榛樿鏈満IP 127.0.0.1): " reverseproxy
		reverseproxy=${reverseproxy:-127.0.0.1}
	fi

	if [ -z "$port" ]; then
		read -e -p "璇疯緭鍏ヤ綘鐨勫弽浠ｇ鍙? " port
	fi
	nginx_install_status


	install_ssltls
	certs_status

	wget -O /home/web/conf.d/map.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/map.conf
	wget -O /home/web/conf.d/$yuming.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/reverse-proxy-backend.conf

	backend=$(tr -dc 'A-Za-z' < /dev/urandom | head -c 8)
	sed -i "s/backend_yuming_com/backend_$backend/g" /home/web/conf.d/"$yuming".conf


	sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

	reverseproxy_port="$reverseproxy:$port"
	upstream_servers=""
	for server in $reverseproxy_port; do
		upstream_servers="$upstream_servers    server $server;\n"
	done

	sed -i "s/# 鍔ㄦ€佹坊鍔?$upstream_servers/g" /home/web/conf.d/$yuming.conf
	sed -i '/remote_addr/d' /home/web/conf.d/$yuming.conf

	update_nginx_listen_port "$yuming" "$access_port"

	nginx_http_on
	docker exec nginx nginx -s reload
	nginx_web_on
}



ldnmp_Proxy_backend() {
	clear
	webname="鍙嶅悜浠ｇ悊-璐熻浇鍧囪　"

	send_stats "瀹夎$webname"
	echo "寮€濮嬮儴缃?$webname"
	if [ -z "$yuming" ]; then
		add_yuming
	fi

	check_ip_and_get_access_port "$yuming"

	if [ -z "$reverseproxy_port" ]; then
		read -e -p "璇疯緭鍏ヤ綘鐨勫涓弽浠P+绔彛鐢ㄧ┖鏍奸殧寮€锛堜緥濡?127.0.0.1:3000 127.0.0.1:3002锛夛細 " reverseproxy_port
	fi

	nginx_install_status

	install_ssltls
	certs_status

	wget -O /home/web/conf.d/map.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/map.conf
	wget -O /home/web/conf.d/$yuming.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/reverse-proxy-backend.conf

	backend=$(tr -dc 'A-Za-z' < /dev/urandom | head -c 8)
	sed -i "s/backend_yuming_com/backend_$backend/g" /home/web/conf.d/"$yuming".conf


	sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

	upstream_servers=""
	for server in $reverseproxy_port; do
		upstream_servers="$upstream_servers    server $server;\n"
	done

	sed -i "s/# 鍔ㄦ€佹坊鍔?$upstream_servers/g" /home/web/conf.d/$yuming.conf


	update_nginx_listen_port "$yuming" "$access_port"

	nginx_http_on
	docker exec nginx nginx -s reload
	nginx_web_on
}






list_stream_services() {

	STREAM_DIR="/home/web/stream.d"
	printf "%-25s %-18s %-25s %-20s\n" "鏈嶅姟鍚? "閫氫俊绫诲瀷" "鏈満鍦板潃" "鍚庣鍦板潃"

	if [ -z "$(ls -A "$STREAM_DIR")" ]; then
		return
	fi

	for conf in "$STREAM_DIR"/*; do
		# 鏈嶅姟鍚嶅彇鏂囦欢鍚?
		service_name=$(basename "$conf" .conf)

		# 鑾峰彇 upstream 鍧椾腑鐨?server 鍚庣 IP:绔彛
		backend=$(grep -Po '(?<=server )[^;]+' "$conf" | head -n1)

		# 鑾峰彇 listen 绔彛
		listen_port=$(grep -Po '(?<=listen )[^;]+' "$conf" | head -n1)

		# 榛樿鏈湴 IP
		ip_address
		local_ip="$ipv4_address"

		# 鑾峰彇閫氫俊绫诲瀷锛屼紭鍏堜粠鏂囦欢鍚嶅悗缂€鎴栧唴瀹瑰垽鏂?
		if grep -qi 'udp;' "$conf"; then
			proto="udp"
		else
			proto="tcp"
		fi

		# 鎷兼帴鐩戝惉 IP:绔彛
		local_addr="$local_ip:$listen_port"

		printf "%-22s %-14s %-21s %-20s\n" "$service_name" "$proto" "$local_addr" "$backend"
	done
}









stream_panel() {
	send_stats "Stream鍥涘眰浠ｇ悊"
	local app_id="104"
	local docker_name="nginx"

	while true; do
		clear
		check_docker_app
		check_docker_image_update $docker_name
		echo -e "Stream鍥涘眰浠ｇ悊杞彂宸ュ叿 $check_docker $update_status"
		echo "NGINX Stream 鏄?NGINX 鐨?TCP/UDP 浠ｇ悊妯″潡锛岀敤浜庡疄鐜伴珮鎬ц兘鐨?浼犺緭灞傛祦閲忚浆鍙戝拰璐熻浇鍧囪　銆?
		echo "------------------------"
		if [ -d "/home/web/stream.d" ]; then
			list_stream_services
		fi
		echo ""
		echo "------------------------"
		echo "1. 瀹夎               2. 鏇存柊               3. 鍗歌浇"
		echo "------------------------"
		echo "4. 娣诲姞杞彂鏈嶅姟       5. 淇敼杞彂鏈嶅姟       6. 鍒犻櫎杞彂鏈嶅姟"
		echo "------------------------"
		echo "0. 杩斿洖涓婁竴绾ч€夊崟"
		echo "------------------------"
		read -e -p "杈撳叆浣犵殑閫夋嫨: " choice
		case $choice in
			1)
				nginx_install_status
				add_app_id
				send_stats "瀹夎Stream鍥涘眰浠ｇ悊"
				;;
			2)
				update_docker_compose_with_db_creds
				nginx_upgrade
				add_app_id
				send_stats "鏇存柊Stream鍥涘眰浠ｇ悊"
				;;
			3)
				read -e -p "纭畾瑕佸垹闄?nginx 瀹瑰櫒鍚楋紵杩欏彲鑳戒細褰卞搷缃戠珯鍔熻兘锛?y/N): " confirm
				if [[ "$confirm" =~ ^[Yy]$ ]]; then
					docker rm -f nginx
					sed -i "/\b${app_id}\b/d" /home/docker/appno.txt
					send_stats "鏇存柊Stream鍥涘眰浠ｇ悊"
					echo "nginx 瀹瑰櫒宸插垹闄ゃ€?
				else
					echo "鎿嶄綔宸插彇娑堛€?
				fi

				;;

			4)
				ldnmp_Proxy_backend_stream
				add_app_id
				send_stats "娣诲姞鍥涘眰浠ｇ悊"
				;;
			5)
				send_stats "缂栬緫杞彂閰嶇疆"
				read -e -p "璇疯緭鍏ヤ綘瑕佺紪杈戠殑鏈嶅姟鍚? " stream_name
				install nano
				nano /home/web/stream.d/$stream_name.conf
				docker restart nginx
				send_stats "淇敼鍥涘眰浠ｇ悊"
				;;
			6)
				send_stats "鍒犻櫎杞彂閰嶇疆"
				read -e -p "璇疯緭鍏ヤ綘瑕佸垹闄ょ殑鏈嶅姟鍚? " stream_name
				rm /home/web/stream.d/$stream_name.conf > /dev/null 2>&1
				docker restart nginx
				send_stats "鍒犻櫎鍥涘眰浠ｇ悊"
				;;
			*)
				break
				;;
		esac
		break_end
	done
}



ldnmp_Proxy_backend_stream() {
	clear
	webname="Stream鍥涘眰浠ｇ悊-璐熻浇鍧囪　"

	send_stats "瀹夎$webname"
	echo "寮€濮嬮儴缃?$webname"

	# 鑾峰彇浠ｇ悊鍚嶇О
	read -erp "璇疯緭鍏ヤ唬鐞嗚浆鍙戝悕绉?(濡?mysql_proxy): " proxy_name
	if [ -z "$proxy_name" ]; then
		echo "鍚嶇О涓嶈兘涓虹┖"; return 1
	fi

	# 鑾峰彇鐩戝惉绔彛
	read -erp "璇疯緭鍏ユ湰鏈虹洃鍚鍙?(濡?3306): " listen_port
	if ! [[ "$listen_port" =~ ^[0-9]+$ ]]; then
		echo "绔彛蹇呴』鏄暟瀛?; return 1
	fi

	echo "璇烽€夋嫨鍗忚绫诲瀷锛?
	echo "1. TCP    2. UDP"
	read -erp "璇疯緭鍏ュ簭鍙?[1-2]: " proto_choice

	case "$proto_choice" in
		1) proto="tcp"; listen_suffix="" ;;
		2) proto="udp"; listen_suffix=" udp" ;;
		*) echo "鏃犳晥閫夋嫨"; return 1 ;;
	esac

	read -e -p "璇疯緭鍏ヤ綘鐨勪竴涓垨鑰呭涓悗绔疘P+绔彛鐢ㄧ┖鏍奸殧寮€锛堜緥濡?10.13.0.2:3306 10.13.0.3:3306锛夛細 " reverseproxy_port

	nginx_install_status
	cd /home && mkdir -p web/stream.d
	grep -q '^[[:space:]]*stream[[:space:]]*{' /home/web/nginx.conf || echo -e '\nstream {\n    include /etc/nginx/stream.d/*.conf;\n}' | tee -a /home/web/nginx.conf
	wget -O /home/web/stream.d/$proxy_name.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/reverse-proxy-backend-stream.conf

	backend=$(tr -dc 'A-Za-z' < /dev/urandom | head -c 8)
	sed -i "s/backend_yuming_com/${proxy_name}_${backend}/g" /home/web/stream.d/"$proxy_name".conf
	sed -i "s|listen 80|listen $listen_port $listen_suffix|g" /home/web/stream.d/$proxy_name.conf
	sed -i "s|listen \[::\]:|listen [::]:${listen_port} ${listen_suffix}|g" "/home/web/stream.d/${proxy_name}.conf"

	upstream_servers=""
	for server in $reverseproxy_port; do
		upstream_servers="$upstream_servers    server $server;\n"
	done

	sed -i "s/# 鍔ㄦ€佹坊鍔?$upstream_servers/g" /home/web/stream.d/$proxy_name.conf

	docker exec nginx nginx -s reload
	clear
	echo "鎮ㄧ殑 $webname 鎼缓濂戒簡锛?
	echo "------------------------"
	echo "璁块棶鍦板潃:"
	ip_address
	if [ -n "$ipv4_address" ]; then
		echo "$ipv4_address:${listen_port}"
	fi
	if [ -n "$ipv6_address" ]; then
		echo "$ipv6_address:${listen_port}"
	fi
	echo ""
}





find_container_by_host_port() {
	port="$1"
	docker_name=$(docker ps --format '{{.ID}} {{.Names}}' | while read id name; do
		if docker port "$id" | grep -q ":$port"; then
			echo "$name"
			break
		fi
	done)
}




ldnmp_web_status() {
	root_use
	while true; do
		local cert_count=$(ls /home/web/certs/*_cert.pem 2>/dev/null | wc -l)
		local output="${gl_lv}${cert_count}${gl_bai}"

		local dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
		local db_count=$(docker exec mysql mysql -u root -p"$dbrootpasswd" -e "SHOW DATABASES;" 2> /dev/null | grep -Ev "Database|information_schema|mysql|performance_schema|sys" | wc -l)
		local db_output="${gl_lv}${db_count}${gl_bai}"

		clear
		send_stats "LDNMP绔欑偣绠＄悊"
		echo "LDNMP鐜"
		echo "------------------------"
		ldnmp_v

		echo -e "绔欑偣: ${output}                      璇佷功鍒版湡鏃堕棿"
		echo -e "------------------------"
		for cert_file in /home/web/certs/*_cert.pem; do
		  local domain=$(basename "$cert_file" | sed 's/_cert.pem//')
		  if [ -n "$domain" ]; then
			local expire_date=$(openssl x509 -noout -enddate -in "$cert_file" | awk -F'=' '{print $2}')
			local formatted_date=$(date -d "$expire_date" '+%Y-%m-%d')
			printf "%-30s%s\n" "$domain" "$formatted_date"
		  fi
		done

		for conf_file in /home/web/conf.d/*_*.conf; do
		  [ -e "$conf_file" ] || continue
		  basename "$conf_file" .conf
		done

		for conf_file in /home/web/conf.d/*.conf; do
		  [ -e "$conf_file" ] || continue

		  filename=$(basename "$conf_file")

		  if [ "$filename" = "map.conf" ] || [ "$filename" = "default.conf" ]; then
			continue
		  fi

		  if ! grep -q "ssl_certificate" "$conf_file"; then
			basename "$conf_file" .conf
		  fi
		done

		echo "------------------------"
		echo ""
		echo -e "鏁版嵁搴? ${db_output}"
		echo -e "------------------------"
		local dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
		docker exec mysql mysql -u root -p"$dbrootpasswd" -e "SHOW DATABASES;" 2> /dev/null | grep -Ev "Database|information_schema|mysql|performance_schema|sys"

		echo "------------------------"
		echo ""
		echo "绔欑偣鐩綍"
		echo "------------------------"
		echo -e "鏁版嵁 ${gl_hui}/home/web/html${gl_bai}     璇佷功 ${gl_hui}/home/web/certs${gl_bai}     閰嶇疆 ${gl_hui}/home/web/conf.d${gl_bai}"
		echo "------------------------"
		echo ""
		echo "鎿嶄綔"
		echo "------------------------"
		echo "1.  鐢宠/鏇存柊鍩熷悕璇佷功               2.  鍏嬮殕绔欑偣鍩熷悕"
		echo "3.  娓呯悊绔欑偣缂撳瓨                    4.  鍒涘缓鍏宠仈绔欑偣"
		echo "5.  鏌ョ湅璁块棶鏃ュ織                    6.  鏌ョ湅閿欒鏃ュ織"
		echo "7.  缂栬緫鍏ㄥ眬閰嶇疆                    8.  缂栬緫绔欑偣閰嶇疆"
		echo "9.  绠＄悊绔欑偣鏁版嵁搴?                 10. 鏌ョ湅绔欑偣鍒嗘瀽鎶ュ憡"
		echo "------------------------"
		echo "20. 鍒犻櫎鎸囧畾绔欑偣鏁版嵁"
		echo "------------------------"
		echo "0. 杩斿洖涓婁竴绾ч€夊崟"
		echo "------------------------"
		read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice
		case $sub_choice in
			1)
				send_stats "鐢宠鍩熷悕璇佷功"
				read -e -p "璇疯緭鍏ヤ綘鐨勫煙鍚? " yuming
				install_certbot
				docker run --rm -v /etc/letsencrypt/:/etc/letsencrypt certbot/certbot delete --cert-name "$yuming" -n 2>/dev/null
				install_ssltls
				certs_status

				;;

			2)
				send_stats "鍏嬮殕绔欑偣鍩熷悕"
				read -e -p "璇疯緭鍏ユ棫鍩熷悕: " oddyuming
				read -e -p "璇疯緭鍏ユ柊鍩熷悕: " yuming
				install_certbot
				install_ssltls
				certs_status


				add_db
				local odd_dbname=$(echo "$oddyuming" | sed -e 's/[^A-Za-z0-9]/_/g')
				local odd_dbname="${odd_dbname}"

				docker exec mysql mysqldump -u root -p"$dbrootpasswd" $odd_dbname | docker exec -i mysql mysql -u root -p"$dbrootpasswd" $dbname

				local tables=$(docker exec mysql mysql -u root -p"$dbrootpasswd" -D $dbname -e "SHOW TABLES;" | awk '{ if (NR>1) print $1 }')
				for table in $tables; do
					columns=$(docker exec mysql mysql -u root -p"$dbrootpasswd" -D $dbname -e "SHOW COLUMNS FROM $table;" | awk '{ if (NR>1) print $1 }')
					for column in $columns; do
						docker exec mysql mysql -u root -p"$dbrootpasswd" -D $dbname -e "UPDATE $table SET $column = REPLACE($column, '$oddyuming', '$yuming') WHERE $column LIKE '%$oddyuming%';"
					done
				done

				# 缃戠珯鐩綍鏇挎崲
				cp -r /home/web/html/$oddyuming /home/web/html/$yuming

				find /home/web/html/$yuming -type f -exec sed -i "s/$odd_dbname/$dbname/g" {} +
				find /home/web/html/$yuming -type f -exec sed -i "s/$oddyuming/$yuming/g" {} +

				cp /home/web/conf.d/$oddyuming.conf /home/web/conf.d/$yuming.conf
				sed -i "s/$oddyuming/$yuming/g" /home/web/conf.d/$yuming.conf

				cd /home/web && docker compose restart

				;;


			3)
				web_cache
				;;
			4)
				send_stats "鍒涘缓鍏宠仈绔欑偣"
				echo -e "涓虹幇鏈夌殑绔欑偣鍐嶅叧鑱斾竴涓柊鍩熷悕鐢ㄤ簬璁块棶"
				read -e -p "璇疯緭鍏ョ幇鏈夌殑鍩熷悕: " oddyuming
				read -e -p "璇疯緭鍏ユ柊鍩熷悕: " yuming
				install_certbot
				install_ssltls
				certs_status

				cp /home/web/conf.d/$oddyuming.conf /home/web/conf.d/$yuming.conf
				sed -i "s|server_name $oddyuming|server_name $yuming|g" /home/web/conf.d/$yuming.conf
				sed -i "s|/etc/nginx/certs/${oddyuming}_cert.pem|/etc/nginx/certs/${yuming}_cert.pem|g" /home/web/conf.d/$yuming.conf
				sed -i "s|/etc/nginx/certs/${oddyuming}_key.pem|/etc/nginx/certs/${yuming}_key.pem|g" /home/web/conf.d/$yuming.conf

				docker exec nginx nginx -s reload

				;;
			5)
				send_stats "鏌ョ湅璁块棶鏃ュ織"
				tail -n 200 /home/web/log/nginx/access.log
				break_end
				;;
			6)
				send_stats "鏌ョ湅閿欒鏃ュ織"
				tail -n 200 /home/web/log/nginx/error.log
				break_end
				;;
			7)
				send_stats "缂栬緫鍏ㄥ眬閰嶇疆"
				install nano
				nano /home/web/nginx.conf
				docker exec nginx nginx -s reload
				;;

			8)
				send_stats "缂栬緫绔欑偣閰嶇疆"
				read -e -p "缂栬緫绔欑偣閰嶇疆锛岃杈撳叆浣犺缂栬緫鐨勫煙鍚? " yuming
				install nano
				nano /home/web/conf.d/$yuming.conf
				docker exec nginx nginx -s reload
				;;
			9)
				phpmyadmin_upgrade
				break_end
				;;
			10)
				send_stats "鏌ョ湅绔欑偣鏁版嵁"
				install goaccess
				goaccess --log-format=COMBINED /home/web/log/nginx/access.log
				;;

			20)
				web_del
				docker run --rm -v /etc/letsencrypt/:/etc/letsencrypt certbot/certbot delete --cert-name "$yuming" -n 2>/dev/null

				;;
			*)
				break  # 璺冲嚭寰幆锛岄€€鍑鸿彍鍗?
				;;
		esac
	done


}


check_panel_app() {
if $lujing > /dev/null 2>&1; then
	check_panel="${gl_lv}宸插畨瑁?{gl_bai}"
else
	check_panel=""
fi
}



install_panel() {
send_stats "${panelname}绠＄悊"
while true; do
	clear
	check_panel_app
	echo -e "$panelname $check_panel"
	echo "${panelname}鏄竴娆炬椂涓嬫祦琛屼笖寮哄ぇ鐨勮繍缁寸鐞嗛潰鏉裤€?
	echo "瀹樼綉浠嬬粛: $panelurl "

	echo ""
	echo "------------------------"
	echo "1. 瀹夎            2. 绠＄悊            3. 鍗歌浇"
	echo "------------------------"
	echo "0. 杩斿洖涓婁竴绾ч€夊崟"
	echo "------------------------"
	read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " choice
	 case $choice in
		1)
			check_disk_space 1
			install wget
			iptables_open
			panel_app_install

			add_app_id
			send_stats "${panelname}瀹夎"
			;;
		2)
			panel_app_manage

			add_app_id
			send_stats "${panelname}鎺у埗"

			;;
		3)
			panel_app_uninstall

			sed -i "/\b${app_id}\b/d" /home/docker/appno.txt
			send_stats "${panelname}鍗歌浇"
			;;
		*)
			break
			;;
	 esac
	 break_end
done

}



check_frp_app() {

if [ -d "/home/frp/" ]; then
	check_frp="${gl_lv}宸插畨瑁?{gl_bai}"
else
	check_frp="${gl_hui}鏈畨瑁?{gl_bai}"
fi

}



donlond_frp() {
  role="$1"
  config_file="/home/frp/${role}.toml"

  docker run -d \
	--name "$role" \
	--restart=always \
	--network host \
	-v "$config_file":"/frp/${role}.toml" \
	kjlion/frp:alpine \
	"/frp/${role}" -c "/frp/${role}.toml"

}




generate_frps_config() {

	send_stats "瀹夎frp鏈嶅姟绔?
	# 鐢熸垚闅忔満绔彛鍜屽嚟璇?
	local bind_port=8055
	local dashboard_port=8056
	local token=$(openssl rand -hex 16)
	local dashboard_user="user_$(openssl rand -hex 4)"
	local dashboard_pwd=$(openssl rand -hex 8)

	mkdir -p /home/frp
	touch /home/frp/frps.toml
	cat <<EOF > /home/frp/frps.toml
[common]
bind_port = $bind_port
authentication_method = token
token = $token
dashboard_port = $dashboard_port
dashboard_user = $dashboard_user
dashboard_pwd = $dashboard_pwd
EOF

	donlond_frp frps

	# 杈撳嚭鐢熸垚鐨勪俊鎭?
	ip_address
	echo "------------------------"
	echo "瀹㈡埛绔儴缃叉椂闇€瑕佺敤鐨勫弬鏁?
	echo "鏈嶅姟IP: $ipv4_address"
	echo "token: $token"
	echo
	echo "FRP闈㈡澘淇℃伅"
	echo "FRP闈㈡澘鍦板潃: http://$ipv4_address:$dashboard_port"
	echo "FRP闈㈡澘鐢ㄦ埛鍚? $dashboard_user"
	echo "FRP闈㈡澘瀵嗙爜: $dashboard_pwd"
	echo

	open_port 8055 8056

}



configure_frpc() {
	send_stats "瀹夎frp瀹㈡埛绔?
	read -e -p "璇疯緭鍏ュ缃戝鎺P: " server_addr
	read -e -p "璇疯緭鍏ュ缃戝鎺oken: " token
	echo

	mkdir -p /home/frp
	touch /home/frp/frpc.toml
	cat <<EOF > /home/frp/frpc.toml
[common]
server_addr = ${server_addr}
server_port = 8055
token = ${token}

EOF

	donlond_frp frpc

	open_port 8055

}

add_forwarding_service() {
	send_stats "娣诲姞frp鍐呯綉鏈嶅姟"
	# 鎻愮ず鐢ㄦ埛杈撳叆鏈嶅姟鍚嶇О鍜岃浆鍙戜俊鎭?
	read -e -p "璇疯緭鍏ユ湇鍔″悕绉? " service_name
	read -e -p "璇疯緭鍏ヨ浆鍙戠被鍨?(tcp/udp) [鍥炶溅榛樿tcp]: " service_type
	local service_type=${service_type:-tcp}
	read -e -p "璇疯緭鍏ュ唴缃慖P [鍥炶溅榛樿127.0.0.1]: " local_ip
	local local_ip=${local_ip:-127.0.0.1}
	read -e -p "璇疯緭鍏ュ唴缃戠鍙? " local_port
	read -e -p "璇疯緭鍏ュ缃戠鍙? " remote_port

	# 灏嗙敤鎴疯緭鍏ュ啓鍏ラ厤缃枃浠?
	cat <<EOF >> /home/frp/frpc.toml
[$service_name]
type = ${service_type}
local_ip = ${local_ip}
local_port = ${local_port}
remote_port = ${remote_port}

EOF

	# 杈撳嚭鐢熸垚鐨勪俊鎭?
	echo "鏈嶅姟 $service_name 宸叉垚鍔熸坊鍔犲埌 frpc.toml"

	docker restart frpc

	open_port $local_port

}



delete_forwarding_service() {
	send_stats "鍒犻櫎frp鍐呯綉鏈嶅姟"
	# 鎻愮ず鐢ㄦ埛杈撳叆闇€瑕佸垹闄ょ殑鏈嶅姟鍚嶇О
	read -e -p "璇疯緭鍏ラ渶瑕佸垹闄ょ殑鏈嶅姟鍚嶇О: " service_name
	# 浣跨敤 sed 鍒犻櫎璇ユ湇鍔″強鍏剁浉鍏抽厤缃?
	sed -i "/\[$service_name\]/,/^$/d" /home/frp/frpc.toml
	echo "鏈嶅姟 $service_name 宸叉垚鍔熶粠 frpc.toml 鍒犻櫎"

	docker restart frpc

}


list_forwarding_services() {
	local config_file="$1"

	# 鎵撳嵃琛ㄥご
	printf "%-20s %-25s %-30s %-10s\n" "鏈嶅姟鍚嶇О" "鍐呯綉鍦板潃" "澶栫綉鍦板潃" "鍗忚"

	awk '
	BEGIN {
		server_addr=""
		server_port=""
		current_service=""
	}

	/^server_addr = / {
		gsub(/"|'"'"'/, "", $3)
		server_addr=$3
	}

	/^server_port = / {
		gsub(/"|'"'"'/, "", $3)
		server_port=$3
	}

	/^\[.*\]/ {
		# 濡傛灉宸叉湁鏈嶅姟淇℃伅锛屽湪澶勭悊鏂版湇鍔′箣鍓嶆墦鍗板綋鍓嶆湇鍔?
		if (current_service != "" && current_service != "common" && local_ip != "" && local_port != "") {
			printf "%-16s %-21s %-26s %-10s\n", \
				current_service, \
				local_ip ":" local_port, \
				server_addr ":" remote_port, \
				type
		}

		# 鏇存柊褰撳墠鏈嶅姟鍚嶇О
		if ($1 != "[common]") {
			gsub(/[\[\]]/, "", $1)
			current_service=$1
			# 娓呴櫎涔嬪墠鐨勫€?
			local_ip=""
			local_port=""
			remote_port=""
			type=""
		}
	}

	/^local_ip = / {
		gsub(/"|'"'"'/, "", $3)
		local_ip=$3
	}

	/^local_port = / {
		gsub(/"|'"'"'/, "", $3)
		local_port=$3
	}

	/^remote_port = / {
		gsub(/"|'"'"'/, "", $3)
		remote_port=$3
	}

	/^type = / {
		gsub(/"|'"'"'/, "", $3)
		type=$3
	}

	END {
		# 鎵撳嵃鏈€鍚庝竴涓湇鍔＄殑淇℃伅
		if (current_service != "" && current_service != "common" && local_ip != "" && local_port != "") {
			printf "%-16s %-21s %-26s %-10s\n", \
				current_service, \
				local_ip ":" local_port, \
				server_addr ":" remote_port, \
				type
		}
	}' "$config_file"
}



# 鑾峰彇 FRP 鏈嶅姟绔鍙?
get_frp_ports() {
	mapfile -t ports < <(ss -tulnape | grep frps | awk '{print $5}' | awk -F':' '{print $NF}' | sort -u)
}

# 鐢熸垚璁块棶鍦板潃
generate_access_urls() {
	# 棣栧厛鑾峰彇鎵€鏈夌鍙?
	get_frp_ports

	# 妫€鏌ユ槸鍚︽湁闈?8055/8056 鐨勭鍙?
	local has_valid_ports=false
	for port in "${ports[@]}"; do
		if [[ $port != "8055" && $port != "8056" ]]; then
			has_valid_ports=true
			break
		fi
	done

	# 鍙湪鏈夋湁鏁堢鍙ｆ椂鏄剧ず鏍囬鍜屽唴瀹?
	if [ "$has_valid_ports" = true ]; then
		echo "FRP鏈嶅姟瀵瑰璁块棶鍦板潃:"

		# 澶勭悊 IPv4 鍦板潃
		for port in "${ports[@]}"; do
			if [[ $port != "8055" && $port != "8056" ]]; then
				echo "http://${ipv4_address}:${port}"
			fi
		done

		# 澶勭悊 IPv6 鍦板潃锛堝鏋滃瓨鍦級
		if [ -n "$ipv6_address" ]; then
			for port in "${ports[@]}"; do
				if [[ $port != "8055" && $port != "8056" ]]; then
					echo "http://[${ipv6_address}]:${port}"
				fi
			done
		fi

		# 澶勭悊 HTTPS 閰嶇疆
		for port in "${ports[@]}"; do
			if [[ $port != "8055" && $port != "8056" ]]; then
				local frps_search_pattern="${ipv4_address}:${port}"
				local frps_search_pattern2="127.0.0.1:${port}"
				for file in /home/web/conf.d/*.conf; do
					if [ -f "$file" ]; then
						if grep -q "$frps_search_pattern" "$file" 2>/dev/null || grep -q "$frps_search_pattern2" "$file" 2>/dev/null; then
							echo "https://$(basename "$file" .conf)"
						fi
					fi
				done
			fi
		done
	fi
}


frps_main_ports() {
	ip_address
	generate_access_urls
}




frps_panel() {
	send_stats "FRP鏈嶅姟绔?
	local app_id="55"
	local docker_name="frps"
	local docker_port=8056
	while true; do
		clear
		check_frp_app
		check_docker_image_update $docker_name
		echo -e "FRP鏈嶅姟绔?$check_frp $update_status"
		echo "鏋勫缓FRP鍐呯綉绌块€忔湇鍔＄幆澧冿紝灏嗘棤鍏綉IP鐨勮澶囨毚闇插埌浜掕仈缃?
		echo "瀹樼綉浠嬬粛: ${gh_https_url}github.com/fatedier/frp/"
		echo "瑙嗛鏁欏: https://www.bilibili.com/video/BV1yMw6e2EwL?t=124.0"
		if [ -d "/home/frp/" ]; then
			check_docker_app_ip
			frps_main_ports
		fi
		echo ""
		echo "------------------------"
		echo "1. 瀹夎                  2. 鏇存柊                  3. 鍗歌浇"
		echo "------------------------"
		echo "5. 鍐呯綉鏈嶅姟鍩熷悕璁块棶      6. 鍒犻櫎鍩熷悕璁块棶"
		echo "------------------------"
		echo "7. 鍏佽IP+绔彛璁块棶       8. 闃绘IP+绔彛璁块棶"
		echo "------------------------"
		echo "00. 鍒锋柊鏈嶅姟鐘舵€?        0. 杩斿洖涓婁竴绾ч€夊崟"
		echo "------------------------"
		read -e -p "杈撳叆浣犵殑閫夋嫨: " choice
		case $choice in
			1)
				install jq grep ss
				install_docker
				generate_frps_config

				add_app_id
				echo "FRP鏈嶅姟绔凡缁忓畨瑁呭畬鎴?
				;;
			2)
				crontab -l | grep -v 'frps' | crontab - > /dev/null 2>&1
				tmux kill-session -t frps >/dev/null 2>&1
				docker rm -f frps && docker rmi kjlion/frp:alpine >/dev/null 2>&1
				[ -f /home/frp/frps.toml ] || cp /home/frp/frp_0.61.0_linux_amd64/frps.toml /home/frp/frps.toml
				donlond_frp frps

				add_app_id
				echo "FRP鏈嶅姟绔凡缁忔洿鏂板畬鎴?
				;;
			3)
				crontab -l | grep -v 'frps' | crontab - > /dev/null 2>&1
				tmux kill-session -t frps >/dev/null 2>&1
				docker rm -f frps && docker rmi kjlion/frp:alpine
				rm -rf /home/frp

				close_port 8055 8056

				sed -i "/\b${app_id}\b/d" /home/docker/appno.txt
				echo "搴旂敤宸插嵏杞?
				;;
			5)
				echo "灏嗗唴缃戠┛閫忔湇鍔″弽浠ｆ垚鍩熷悕璁块棶"
				send_stats "FRP瀵瑰鍩熷悕璁块棶"
				add_yuming
				read -e -p "璇疯緭鍏ヤ綘鐨勫唴缃戠┛閫忔湇鍔＄鍙? " frps_port
				ldnmp_Proxy ${yuming} 127.0.0.1 ${frps_port}
				block_host_port "$frps_port" "$ipv4_address"
				;;
			6)
				echo "鍩熷悕鏍煎紡 example.com 涓嶅甫https://"
				web_del
				;;

			7)
				send_stats "鍏佽IP璁块棶"
				read -e -p "璇疯緭鍏ラ渶瑕佹斁琛岀殑绔彛: " frps_port
				clear_host_port_rules "$frps_port" "$ipv4_address"
				;;

			8)
				send_stats "闃绘IP璁块棶"
				echo "濡傛灉浣犲凡缁忓弽浠ｅ煙鍚嶈闂簡锛屽彲鐢ㄦ鍔熻兘闃绘IP+绔彛璁块棶锛岃繖鏍锋洿瀹夊叏銆?
				read -e -p "璇疯緭鍏ラ渶瑕侀樆姝㈢殑绔彛: " frps_port
				block_host_port "$frps_port" "$ipv4_address"
				;;

			00)
				send_stats "鍒锋柊FRP鏈嶅姟鐘舵€?
				echo "宸茬粡鍒锋柊FRP鏈嶅姟鐘舵€?
				;;

			*)
				break
				;;
		esac
		break_end
	done
}


frpc_panel() {
	send_stats "FRP瀹㈡埛绔?
	local app_id="56"
	local docker_name="frpc"
	local docker_port=8055
	while true; do
		clear
		check_frp_app
		check_docker_image_update $docker_name
		echo -e "FRP瀹㈡埛绔?$check_frp $update_status"
		echo "涓庢湇鍔＄瀵规帴锛屽鎺ュ悗鍙垱寤哄唴缃戠┛閫忔湇鍔″埌浜掕仈缃戣闂?
		echo "瀹樼綉浠嬬粛: ${gh_https_url}github.com/fatedier/frp/"
		echo "瑙嗛鏁欏: https://www.bilibili.com/video/BV1yMw6e2EwL?t=173.9"
		echo "------------------------"
		if [ -d "/home/frp/" ]; then
			[ -f /home/frp/frpc.toml ] || cp /home/frp/frp_0.61.0_linux_amd64/frpc.toml /home/frp/frpc.toml
			list_forwarding_services "/home/frp/frpc.toml"
		fi
		echo ""
		echo "------------------------"
		echo "1. 瀹夎               2. 鏇存柊               3. 鍗歌浇"
		echo "------------------------"
		echo "4. 娣诲姞瀵瑰鏈嶅姟       5. 鍒犻櫎瀵瑰鏈嶅姟       6. 鎵嬪姩閰嶇疆鏈嶅姟"
		echo "------------------------"
		echo "0. 杩斿洖涓婁竴绾ч€夊崟"
		echo "------------------------"
		read -e -p "杈撳叆浣犵殑閫夋嫨: " choice
		case $choice in
			1)
				install jq grep ss
				install_docker
				configure_frpc

				add_app_id
				echo "FRP瀹㈡埛绔凡缁忓畨瑁呭畬鎴?
				;;
			2)
				crontab -l | grep -v 'frpc' | crontab - > /dev/null 2>&1
				tmux kill-session -t frpc >/dev/null 2>&1
				docker rm -f frpc && docker rmi kjlion/frp:alpine >/dev/null 2>&1
				[ -f /home/frp/frpc.toml ] || cp /home/frp/frp_0.61.0_linux_amd64/frpc.toml /home/frp/frpc.toml
				donlond_frp frpc

				add_app_id
				echo "FRP瀹㈡埛绔凡缁忔洿鏂板畬鎴?
				;;

			3)
				crontab -l | grep -v 'frpc' | crontab - > /dev/null 2>&1
				tmux kill-session -t frpc >/dev/null 2>&1
				docker rm -f frpc && docker rmi kjlion/frp:alpine
				rm -rf /home/frp
				close_port 8055

				sed -i "/\b${app_id}\b/d" /home/docker/appno.txt
				echo "搴旂敤宸插嵏杞?
				;;

			4)
				add_forwarding_service
				;;

			5)
				delete_forwarding_service
				;;

			6)
				install nano
				nano /home/frp/frpc.toml
				docker restart frpc
				;;

			*)
				break
				;;
		esac
		break_end
	done
}




yt_menu_pro() {

	local app_id="66"
	local VIDEO_DIR="/home/yt-dlp"
	local URL_FILE="$VIDEO_DIR/urls.txt"
	local ARCHIVE_FILE="$VIDEO_DIR/archive.txt"

	mkdir -p "$VIDEO_DIR"

	while true; do

		if [ -x "/usr/local/bin/yt-dlp" ]; then
		   local YTDLP_STATUS="${gl_lv}宸插畨瑁?{gl_bai}"
		else
		   local YTDLP_STATUS="${gl_hui}鏈畨瑁?{gl_bai}"
		fi

		clear
		send_stats "yt-dlp 涓嬭浇宸ュ叿"
		echo -e "yt-dlp $YTDLP_STATUS"
		echo -e "yt-dlp 鏄竴涓姛鑳藉己澶х殑瑙嗛涓嬭浇宸ュ叿锛屾敮鎸?YouTube銆丅ilibili銆乀witter 绛夋暟鍗冪珯鐐广€?
		echo -e "瀹樼綉鍦板潃锛?{gh_https_url}github.com/yt-dlp/yt-dlp"
		echo "-------------------------"
		echo "宸蹭笅杞借棰戝垪琛?"
		ls -td "$VIDEO_DIR"/*/ 2>/dev/null || echo "锛堟殏鏃狅級"
		echo "-------------------------"
		echo "1.  瀹夎               2.  鏇存柊               3.  鍗歌浇"
		echo "-------------------------"
		echo "5.  鍗曚釜瑙嗛涓嬭浇       6.  鎵归噺瑙嗛涓嬭浇       7.  鑷畾涔夊弬鏁颁笅杞?
		echo "8.  涓嬭浇涓篗P3闊抽      9.  鍒犻櫎瑙嗛鐩綍       10. Cookie绠＄悊锛堝紑鍙戜腑锛?
		echo "-------------------------"
		echo "0. 杩斿洖涓婁竴绾ч€夊崟"
		echo "-------------------------"
		read -e -p "璇疯緭鍏ラ€夐」缂栧彿: " choice

		case $choice in
			1)
				send_stats "姝ｅ湪瀹夎 yt-dlp..."
				echo "姝ｅ湪瀹夎 yt-dlp..."
				install ffmpeg
				curl -L ${gh_https_url}github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
				chmod a+rx /usr/local/bin/yt-dlp

				add_app_id
				echo "瀹夎瀹屾垚銆傛寜浠绘剰閿户缁?.."
				read ;;
			2)
				send_stats "姝ｅ湪鏇存柊 yt-dlp..."
				echo "姝ｅ湪鏇存柊 yt-dlp..."
				yt-dlp -U

				add_app_id
				echo "鏇存柊瀹屾垚銆傛寜浠绘剰閿户缁?.."
				read ;;
			3)
				send_stats "姝ｅ湪鍗歌浇 yt-dlp..."
				echo "姝ｅ湪鍗歌浇 yt-dlp..."
				rm -f /usr/local/bin/yt-dlp

				sed -i "/\b${app_id}\b/d" /home/docker/appno.txt
				echo "鍗歌浇瀹屾垚銆傛寜浠绘剰閿户缁?.."
				read ;;
			5)
				send_stats "鍗曚釜瑙嗛涓嬭浇"
				read -e -p "璇疯緭鍏ヨ棰戦摼鎺? " url
				yt-dlp -P "$VIDEO_DIR" -f "bv*+ba/b" --merge-output-format mp4 \
					--write-subs --sub-langs all \
					--write-thumbnail --embed-thumbnail \
					--write-info-json \
					-o "$VIDEO_DIR/%(title)s/%(title)s.%(ext)s" \
					--no-overwrites --no-post-overwrites "$url"
				read -e -p "涓嬭浇瀹屾垚锛屾寜浠绘剰閿户缁?.." ;;
			6)
				send_stats "鎵归噺瑙嗛涓嬭浇"
				install nano
				if [ ! -f "$URL_FILE" ]; then
				  echo -e "# 杈撳叆澶氫釜瑙嗛閾炬帴鍦板潃\n# https://www.bilibili.com/bangumi/play/ep733316?spm_id_from=333.337.0.0&from_spmid=666.25.episode.0" > "$URL_FILE"
				fi
				nano $URL_FILE
				echo "鐜板湪寮€濮嬫壒閲忎笅杞?.."
				yt-dlp -P "$VIDEO_DIR" -f "bv*+ba/b" --merge-output-format mp4 \
					--write-subs --sub-langs all \
					--write-thumbnail --embed-thumbnail \
					--write-info-json \
					-a "$URL_FILE" \
					-o "$VIDEO_DIR/%(title)s/%(title)s.%(ext)s" \
					--no-overwrites --no-post-overwrites
				read -e -p "鎵归噺涓嬭浇瀹屾垚锛屾寜浠绘剰閿户缁?.." ;;
			7)
				send_stats "鑷畾涔夎棰戜笅杞?
				read -e -p "璇疯緭鍏ュ畬鏁?yt-dlp 鍙傛暟锛堜笉鍚?yt-dlp锛? " custom
				yt-dlp -P "$VIDEO_DIR" $custom \
					--write-subs --sub-langs all \
					--write-thumbnail --embed-thumbnail \
					--write-info-json \
					-o "$VIDEO_DIR/%(title)s/%(title)s.%(ext)s" \
					--no-overwrites --no-post-overwrites
				read -e -p "鎵ц瀹屾垚锛屾寜浠绘剰閿户缁?.." ;;
			8)
				send_stats "MP3涓嬭浇"
				read -e -p "璇疯緭鍏ヨ棰戦摼鎺? " url
				yt-dlp -P "$VIDEO_DIR" -x --audio-format mp3 \
					--write-subs --sub-langs all \
					--write-thumbnail --embed-thumbnail \
					--write-info-json \
					-o "$VIDEO_DIR/%(title)s/%(title)s.%(ext)s" \
					--no-overwrites --no-post-overwrites "$url"
				read -e -p "闊抽涓嬭浇瀹屾垚锛屾寜浠绘剰閿户缁?.." ;;

			9)
				send_stats "鍒犻櫎瑙嗛"
				read -e -p "璇疯緭鍏ュ垹闄よ棰戝悕绉? " rmdir
				rm -rf "$VIDEO_DIR/$rmdir"
				;;
			*)
				break ;;
		esac
	done
}





current_timezone() {
	if grep -q 'Alpine' /etc/issue; then
	   date +"%Z %z"
	else
	   timedatectl | grep "Time zone" | awk '{print $3}'
	fi

}


set_timedate() {
	local shiqu="$1"
	if grep -q 'Alpine' /etc/issue; then
		install tzdata
		cp /usr/share/zoneinfo/${shiqu} /etc/localtime
		hwclock --systohc
	else
		timedatectl set-timezone ${shiqu}
	fi
}



# 淇dpkg涓柇闂
fix_dpkg() {
	pkill -9 -f 'apt|dpkg'
	rm -f /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock
	DEBIAN_FRONTEND=noninteractive dpkg --configure -a
}


linux_update() {
	echo -e "${gl_kjlan}姝ｅ湪绯荤粺鏇存柊...${gl_bai}"
	if command -v dnf &>/dev/null; then
		dnf -y update
	elif command -v yum &>/dev/null; then
		yum -y update
	elif command -v apt &>/dev/null; then
		fix_dpkg
		DEBIAN_FRONTEND=noninteractive apt update -y
		DEBIAN_FRONTEND=noninteractive apt full-upgrade -y
	elif command -v apk &>/dev/null; then
		apk update && apk upgrade
	elif command -v pacman &>/dev/null; then
		pacman -Syu --noconfirm
	elif command -v zypper &>/dev/null; then
		zypper refresh
		zypper update
	elif command -v opkg &>/dev/null; then
		opkg update
	else
		echo "鏈煡鐨勫寘绠＄悊鍣?"
		return
	fi
}



linux_clean() {
	echo -e "${gl_kjlan}姝ｅ湪绯荤粺娓呯悊...${gl_bai}"
	if command -v dnf &>/dev/null; then
		rpm --rebuilddb
		dnf autoremove -y
		dnf clean all
		dnf makecache
		journalctl --rotate
		journalctl --vacuum-time=1s
		journalctl --vacuum-size=500M

	elif command -v yum &>/dev/null; then
		rpm --rebuilddb
		yum autoremove -y
		yum clean all
		yum makecache
		journalctl --rotate
		journalctl --vacuum-time=1s
		journalctl --vacuum-size=500M

	elif command -v apt &>/dev/null; then
		fix_dpkg
		apt autoremove --purge -y
		apt clean -y
		apt autoclean -y
		journalctl --rotate
		journalctl --vacuum-time=1s
		journalctl --vacuum-size=500M

	elif command -v apk &>/dev/null; then
		echo "娓呯悊鍖呯鐞嗗櫒缂撳瓨..."
		apk cache clean
		echo "鍒犻櫎绯荤粺鏃ュ織..."
		rm -rf /var/log/*
		echo "鍒犻櫎APK缂撳瓨..."
		rm -rf /var/cache/apk/*
		echo "鍒犻櫎涓存椂鏂囦欢..."
		rm -rf /tmp/*

	elif command -v pacman &>/dev/null; then
		pacman -Rns $(pacman -Qdtq) --noconfirm
		pacman -Scc --noconfirm
		journalctl --rotate
		journalctl --vacuum-time=1s
		journalctl --vacuum-size=500M

	elif command -v zypper &>/dev/null; then
		zypper clean --all
		zypper refresh
		journalctl --rotate
		journalctl --vacuum-time=1s
		journalctl --vacuum-size=500M

	elif command -v opkg &>/dev/null; then
		echo "鍒犻櫎绯荤粺鏃ュ織..."
		rm -rf /var/log/*
		echo "鍒犻櫎涓存椂鏂囦欢..."
		rm -rf /tmp/*

	elif command -v pkg &>/dev/null; then
		echo "娓呯悊鏈娇鐢ㄧ殑渚濊禆..."
		pkg autoremove -y
		echo "娓呯悊鍖呯鐞嗗櫒缂撳瓨..."
		pkg clean -y
		echo "鍒犻櫎绯荤粺鏃ュ織..."
		rm -rf /var/log/*
		echo "鍒犻櫎涓存椂鏂囦欢..."
		rm -rf /tmp/*

	else
		echo "鏈煡鐨勫寘绠＄悊鍣?"
		return
	fi
	return
}



bbr_on() {

sed -i '/net.ipv4.tcp_congestion_control=/d' /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p

}


set_dns() {

ip_address

chattr -i /etc/resolv.conf
> /etc/resolv.conf

if [ -n "$ipv4_address" ]; then
	echo "nameserver $dns1_ipv4" >> /etc/resolv.conf
	echo "nameserver $dns2_ipv4" >> /etc/resolv.conf
fi

if [ -n "$ipv6_address" ]; then
	echo "nameserver $dns1_ipv6" >> /etc/resolv.conf
	echo "nameserver $dns2_ipv6" >> /etc/resolv.conf
fi

if [ ! -s /etc/resolv.conf ]; then
	echo "nameserver 223.5.5.5" >> /etc/resolv.conf
	echo "nameserver 8.8.8.8" >> /etc/resolv.conf
fi

chattr +i /etc/resolv.conf

}


set_dns_ui() {
root_use
send_stats "浼樺寲DNS"
while true; do
	clear
	echo "浼樺寲DNS鍦板潃"
	echo "------------------------"
	echo "褰撳墠DNS鍦板潃"
	cat /etc/resolv.conf
	echo "------------------------"
	echo ""
	echo "1. 鍥藉DNS浼樺寲: "
	echo " v4: 1.1.1.1 8.8.8.8"
	echo " v6: 2606:4700:4700::1111 2001:4860:4860::8888"
	echo "2. 鍥藉唴DNS浼樺寲: "
	echo " v4: 223.5.5.5 183.60.83.19"
	echo " v6: 2400:3200::1 2400:da00::6666"
	echo "3. 鎵嬪姩缂栬緫DNS閰嶇疆"
	echo "------------------------"
	echo "0. 杩斿洖涓婁竴绾ч€夊崟"
	echo "------------------------"
	read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " Limiting
	case "$Limiting" in
	  1)
		local dns1_ipv4="1.1.1.1"
		local dns2_ipv4="8.8.8.8"
		local dns1_ipv6="2606:4700:4700::1111"
		local dns2_ipv6="2001:4860:4860::8888"
		set_dns
		send_stats "鍥藉DNS浼樺寲"
		;;
	  2)
		local dns1_ipv4="223.5.5.5"
		local dns2_ipv4="183.60.83.19"
		local dns1_ipv6="2400:3200::1"
		local dns2_ipv6="2400:da00::6666"
		set_dns
		send_stats "鍥藉唴DNS浼樺寲"
		;;
	  3)
		install nano
		chattr -i /etc/resolv.conf
		nano /etc/resolv.conf
		chattr +i /etc/resolv.conf
		send_stats "鎵嬪姩缂栬緫DNS閰嶇疆"
		;;
	  *)
		break
		;;
	esac
done

}



restart_ssh() {
	restart sshd ssh > /dev/null 2>&1

}



correct_ssh_config() {

	local sshd_config="/etc/ssh/sshd_config"


	if grep -Eq "^\s*PasswordAuthentication\s+no" "$sshd_config"; then
		sed -i -e 's/^\s*#\?\s*PermitRootLogin .*/PermitRootLogin prohibit-password/' \
			   -e 's/^\s*#\?\s*PasswordAuthentication .*/PasswordAuthentication no/' \
			   -e 's/^\s*#\?\s*PubkeyAuthentication .*/PubkeyAuthentication yes/' \
			   -e 's/^\s*#\?\s*ChallengeResponseAuthentication .*/ChallengeResponseAuthentication no/' "$sshd_config"
	else
		sed -i -e 's/^\s*#\?\s*PermitRootLogin .*/PermitRootLogin yes/' \
			   -e 's/^\s*#\?\s*PasswordAuthentication .*/PasswordAuthentication yes/' \
			   -e 's/^\s*#\?\s*PubkeyAuthentication .*/PubkeyAuthentication yes/' "$sshd_config"
	fi

	rm -rf /etc/ssh/sshd_config.d/* /etc/ssh/ssh_config.d/*
}


new_ssh_port() {

  local new_port=$1

  cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

  sed -i '/^\s*#\?\s*Port\s\+/d' /etc/ssh/sshd_config
  echo "Port $new_port" >> /etc/ssh/sshd_config

  correct_ssh_config

  restart_ssh
  open_port $new_port
  remove iptables-persistent ufw firewalld iptables-services > /dev/null 2>&1

  echo "SSH 绔彛宸蹭慨鏀逛负: $new_port"

  sleep 1

}



sshkey_on() {

	sed -i -e 's/^\s*#\?\s*PermitRootLogin .*/PermitRootLogin prohibit-password/' \
		   -e 's/^\s*#\?\s*PasswordAuthentication .*/PasswordAuthentication no/' \
		   -e 's/^\s*#\?\s*PubkeyAuthentication .*/PubkeyAuthentication yes/' \
		   -e 's/^\s*#\?\s*ChallengeResponseAuthentication .*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
	rm -rf /etc/ssh/sshd_config.d/* /etc/ssh/ssh_config.d/*
	restart_ssh
	echo -e "${gl_lv}鐢ㄦ埛瀵嗛挜鐧诲綍妯″紡宸插紑鍚紝宸插叧闂瘑鐮佺櫥褰曟ā寮忥紝閲嶈繛灏嗕細鐢熸晥${gl_bai}"

}



add_sshkey() {
	chmod 700 "${HOME}"
	mkdir -p "${HOME}/.ssh"
	chmod 700 "${HOME}/.ssh"
	touch "${HOME}/.ssh/authorized_keys"

	ssh-keygen -t ed25519 -C "xxxx@gmail.com" -f "${HOME}/.ssh/sshkey" -N ""

	cat "${HOME}/.ssh/sshkey.pub" >> "${HOME}/.ssh/authorized_keys"
	chmod 600 "${HOME}/.ssh/authorized_keys"

	ip_address
	echo -e "绉侀挜淇℃伅宸茬敓鎴愶紝鍔″繀澶嶅埗淇濆瓨锛屽彲淇濆瓨鎴?${gl_huang}${ipv4_address}_ssh.key${gl_bai} 鏂囦欢锛岀敤浜庝互鍚庣殑SSH鐧诲綍"

	echo "--------------------------------"
	cat "${HOME}/.ssh/sshkey"
	echo "--------------------------------"

	sshkey_on
}





import_sshkey() {

	local public_key="$1"
	local base_dir="${2:-$HOME}"
	local ssh_dir="${base_dir}/.ssh"
	local auth_keys="${ssh_dir}/authorized_keys"

	if [[ -z "$public_key" ]]; then
		read -e -p "璇疯緭鍏ユ偍鐨凷SH鍏挜鍐呭锛堥€氬父浠?'ssh-rsa' 鎴?'ssh-ed25519' 寮€澶达級: " public_key
	fi

	if [[ -z "$public_key" ]]; then
		echo -e "${gl_hong}閿欒锛氭湭杈撳叆鍏挜鍐呭銆?{gl_bai}"
		return 1
	fi

	if [[ ! "$public_key" =~ ^ssh-(rsa|ed25519|ecdsa) ]]; then
		echo -e "${gl_hong}閿欒锛氱湅璧锋潵涓嶅儚鍚堟硶鐨?SSH 鍏挜銆?{gl_bai}"
		return 1
	fi

	if grep -Fxq "$public_key" "$auth_keys" 2>/dev/null; then
		echo "璇ュ叕閽ュ凡瀛樺湪锛屾棤闇€閲嶅娣诲姞"
		return 0
	fi

	mkdir -p "$ssh_dir"
	chmod 700 "$ssh_dir"
	touch "$auth_keys"
	echo "$public_key" >> "$auth_keys"
	chmod 600 "$auth_keys"

	sshkey_on
}



fetch_remote_ssh_keys() {

	local keys_url="$1"
	local base_dir="${2:-$HOME}"
	local ssh_dir="${base_dir}/.ssh"
	local authorized_keys="${ssh_dir}/authorized_keys"
	local temp_file

	if [[ -z "${keys_url}" ]]; then
		read -e -p "璇疯緭鍏ユ偍鐨勮繙绔叕閽RL锛?" keys_url
	fi

	echo "姝よ剼鏈皢浠庤繙绋?URL 鎷夊彇 SSH 鍏挜锛屽苟娣诲姞鍒?${authorized_keys}"
	echo ""
	echo "杩滅▼鍏挜鍦板潃锛?
	echo "  ${keys_url}"
	echo ""

	# 鍒涘缓涓存椂鏂囦欢
	temp_file=$(mktemp)

	# 涓嬭浇鍏挜
	if command -v curl >/dev/null 2>&1; then
		curl -fsSL --connect-timeout 10 "${keys_url}" -o "${temp_file}" || {
			echo "閿欒锛氭棤娉曚粠 URL 涓嬭浇鍏挜锛堢綉缁滈棶棰樻垨鍦板潃鏃犳晥锛? >&2
			rm -f "${temp_file}"
			return 1
		}
	elif command -v wget >/dev/null 2>&1; then
		wget -q --timeout=10 -O "${temp_file}" "${keys_url}" || {
			echo "閿欒锛氭棤娉曚粠 URL 涓嬭浇鍏挜锛堢綉缁滈棶棰樻垨鍦板潃鏃犳晥锛? >&2
			rm -f "${temp_file}"
			return 1
		}
	else
		echo "閿欒锛氱郴缁熶腑鏈壘鍒?curl 鎴?wget锛屾棤娉曚笅杞藉叕閽? >&2
		rm -f "${temp_file}"
		return 1
	fi

	# 妫€鏌ュ唴瀹规槸鍚︽湁鏁?
	if [[ ! -s "${temp_file}" ]]; then
		echo "閿欒锛氫笅杞藉埌鐨勬枃浠朵负绌猴紝URL 鍙兘涓嶅寘鍚换浣曞叕閽? >&2
		rm -f "${temp_file}"
		return 1
	fi

	mkdir -p "${ssh_dir}"
	chmod 700 "${ssh_dir}"
	touch "${authorized_keys}"
	chmod 600 "${authorized_keys}"

	# 澶囦唤鍘熸湁 authorized_keys
	if [[ -f "${authorized_keys}" ]]; then
		cp "${authorized_keys}" "${authorized_keys}.bak.$(date +%Y%m%d-%H%M%S)"
		echo "宸插浠藉師鏈?authorized_keys 鏂囦欢"
	fi

	# 杩藉姞鍏挜锛堥伩鍏嶉噸澶嶏級
	local added=0
	while IFS= read -r line; do
		[[ -z "${line}" || "${line}" =~ ^# ]] && continue

		if ! grep -Fxq "${line}" "${authorized_keys}" 2>/dev/null; then
			echo "${line}" >> "${authorized_keys}"
			((added++))
		fi
	done < "${temp_file}"

	rm -f "${temp_file}"

	echo ""
	if (( added > 0 )); then
		echo "鎴愬姛娣诲姞 ${added} 鏉℃柊鐨勫叕閽ュ埌 ${authorized_keys}"
		sshkey_on
	else
		echo "娌℃湁鏂扮殑鍏挜闇€瑕佹坊鍔狅紙鍙兘宸插叏閮ㄥ瓨鍦級"
	fi

	echo ""
}




fetch_github_ssh_keys() {

	local username="$1"
	local base_dir="${2:-$HOME}"

	echo "鎿嶄綔鍓嶏紝璇风‘淇濇偍宸插湪 GitHub 璐︽埛涓坊鍔犱簡 SSH 鍏挜锛?
	echo "  1. 鐧诲綍 ${gh_https_url}github.com/settings/keys"
	echo "  2. 鐐瑰嚮 New SSH key 鎴?Add SSH key"
	echo "  3. Title 鍙殢鎰忓～鍐欙紙渚嬪锛欻ome Laptop 2026锛?
	echo "  4. 灏嗘湰鍦板叕閽ュ唴瀹癸紙閫氬父鏄?~/.ssh/id_ed25519.pub 鎴?id_rsa.pub 鐨勫叏閮ㄥ唴瀹癸級绮樿创鍒?Key 瀛楁"
	echo "  5. 鐐瑰嚮 Add SSH key 瀹屾垚娣诲姞"
	echo ""
	echo "娣诲姞瀹屾垚鍚庯紝GitHub 浼氬叕寮€鎻愪緵鎮ㄧ殑鎵€鏈夊叕閽ワ紝鍦板潃涓猴細"
	echo "  ${gh_https_url}github.com/鎮ㄧ殑鐢ㄦ埛鍚?keys"
	echo ""


	if [[ -z "${username}" ]]; then
		read -e -p "璇疯緭鍏ユ偍鐨?GitHub 鐢ㄦ埛鍚嶏紙username锛屼笉鍚?@锛夛細 " username
	fi

	if [[ -z "${username}" ]]; then
		echo "閿欒锛欸itHub 鐢ㄦ埛鍚嶄笉鑳戒负绌? >&2
		return 1
	fi

	keys_url="${gh_https_url}github.com/${username}.keys"

	fetch_remote_ssh_keys "${keys_url}" "${base_dir}"

}


sshkey_panel() {
  root_use
  send_stats "鐢ㄦ埛瀵嗛挜鐧诲綍"
  while true; do
	  clear
	  local REAL_STATUS=$(grep -i "^PubkeyAuthentication" /etc/ssh/sshd_config | tr '[:upper:]' '[:lower:]')
	  if [[ "$REAL_STATUS" =~ "yes" ]]; then
		  IS_KEY_ENABLED="${gl_lv}宸插惎鐢?{gl_bai}"
	  else
	  	  IS_KEY_ENABLED="${gl_hui}鏈惎鐢?{gl_bai}"
	  fi
  	  echo -e "鐢ㄦ埛瀵嗛挜鐧诲綍妯″紡 ${IS_KEY_ENABLED}"
  	  echo "杩涢樁鐜╂硶: https://blog.kejilion.pro/ssh-key"
  	  echo "------------------------------------------------"
  	  echo "灏嗕細鐢熸垚瀵嗛挜瀵癸紝鏇村畨鍏ㄧ殑鏂瑰紡SSH鐧诲綍"
	  echo "------------------------"
	  echo "1. 鐢熸垚鏂板瘑閽ュ                  2. 鎵嬪姩杈撳叆宸叉湁鍏挜"
	  echo "3. 浠嶨itHub瀵煎叆宸叉湁鍏挜          4. 浠嶶RL瀵煎叆宸叉湁鍏挜"
	  echo "5. 缂栬緫鍏挜鏂囦欢                  6. 鏌ョ湅鏈満瀵嗛挜"
	  echo "------------------------"
	  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
	  echo "------------------------"
	  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " host_dns
	  case $host_dns in
		  1)
	  		send_stats "鐢熸垚鏂板瘑閽?
	  		add_sshkey
			break_end
			  ;;
		  2)
			send_stats "瀵煎叆宸叉湁鍏挜"
			import_sshkey
			break_end
			  ;;
		  3)
			send_stats "瀵煎叆GitHub杩滅鍏挜"
			fetch_github_ssh_keys
			break_end
			  ;;
		  4)
			send_stats "瀵煎叆URL杩滅鍏挜"
			read -e -p "璇疯緭鍏ユ偍鐨勮繙绔叕閽RL锛?" keys_url
			fetch_remote_ssh_keys "${keys_url}"
			break_end
			  ;;

		  5)
			send_stats "缂栬緫鍏挜鏂囦欢"
			install nano
			nano ${HOME}/.ssh/authorized_keys
			break_end
			  ;;

		  6)
			send_stats "鏌ョ湅鏈満瀵嗛挜"
			echo "------------------------"
			echo "鍏挜淇℃伅"
			cat ${HOME}/.ssh/authorized_keys
			echo "------------------------"
			echo "绉侀挜淇℃伅"
			cat ${HOME}/.ssh/sshkey
			echo "------------------------"
			break_end
			  ;;
		  *)
			  break  # 璺冲嚭寰幆锛岄€€鍑鸿彍鍗?
			  ;;
	  esac
  done


}






add_sshpasswd() {

	root_use
	send_stats "璁剧疆瀵嗙爜鐧诲綍妯″紡"
	echo "璁剧疆瀵嗙爜鐧诲綍妯″紡"

	local target_user="$1"

	# 濡傛灉娌℃湁閫氳繃鍙傛暟浼犲叆锛屽垯浜や簰杈撳叆
	if [[ -z "$target_user" ]]; then
		read -e -p "璇疯緭鍏ヨ淇敼瀵嗙爜鐨勭敤鎴峰悕锛堥粯璁?root锛? " target_user
	fi

	# 鍥炶溅涓嶈緭鍏ワ紝榛樿 root
	target_user=${target_user:-root}

	# 鏍￠獙鐢ㄦ埛鏄惁瀛樺湪
	if ! id "$target_user" >/dev/null 2>&1; then
		echo "閿欒锛氱敤鎴?$target_user 涓嶅瓨鍦?
		return 1
	fi

	passwd "$target_user"

	if [[ "$target_user" == "root" ]]; then
		sed -i 's/^\s*#\?\s*PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
	fi

	sed -i 's/^\s*#\?\s*PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
	rm -rf /etc/ssh/sshd_config.d/* /etc/ssh/ssh_config.d/*

	restart_ssh

	echo -e "${gl_lv}瀵嗙爜璁剧疆瀹屾瘯锛屽凡鏇存敼涓哄瘑鐮佺櫥褰曟ā寮忥紒${gl_bai}"
}














root_use() {
clear
[ "$EUID" -ne 0 ] && echo -e "${gl_huang}鎻愮ず: ${gl_bai}璇ュ姛鑳介渶瑕乺oot鐢ㄦ埛鎵嶈兘杩愯锛? && break_end && kejilion
}












dd_xitong() {
		send_stats "閲嶈绯荤粺"
		dd_xitong_MollyLau() {
			wget --no-check-certificate -qO InstallNET.sh "${gh_proxy}raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh" && chmod a+x InstallNET.sh

		}

		dd_xitong_bin456789() {
			curl -O ${gh_proxy}raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh
		}

		dd_xitong_1() {
		  echo -e "閲嶈鍚庡垵濮嬬敤鎴峰悕: ${gl_huang}root${gl_bai}  鍒濆瀵嗙爜: ${gl_huang}LeitboGi0ro${gl_bai}  鍒濆绔彛: ${gl_huang}22${gl_bai}"
		  echo -e "${gl_huang}閲嶈鍚庤鍙婃椂淇敼鍒濆瀵嗙爜锛岄槻姝㈡毚鍔涘叆渚点€傚懡浠よ杈撳叆passwd淇敼瀵嗙爜${gl_bai}"
		  echo -e "鎸変换鎰忛敭缁х画..."
		  read -n 1 -s -r -p ""
		  install wget
		  dd_xitong_MollyLau
		}

		dd_xitong_2() {
		  echo -e "閲嶈鍚庡垵濮嬬敤鎴峰悕: ${gl_huang}Administrator${gl_bai}  鍒濆瀵嗙爜: ${gl_huang}Teddysun.com${gl_bai}  鍒濆绔彛: ${gl_huang}3389${gl_bai}"
		  echo -e "鎸変换鎰忛敭缁х画..."
		  read -n 1 -s -r -p ""
		  install wget
		  dd_xitong_MollyLau
		}

		dd_xitong_3() {
		  echo -e "閲嶈鍚庡垵濮嬬敤鎴峰悕: ${gl_huang}root${gl_bai}  鍒濆瀵嗙爜: ${gl_huang}123@@@${gl_bai}  鍒濆绔彛: ${gl_huang}22${gl_bai}"
		  echo -e "鎸変换鎰忛敭缁х画..."
		  read -n 1 -s -r -p ""
		  dd_xitong_bin456789
		}

		dd_xitong_4() {
		  echo -e "閲嶈鍚庡垵濮嬬敤鎴峰悕: ${gl_huang}Administrator${gl_bai}  鍒濆瀵嗙爜: ${gl_huang}123@@@${gl_bai}  鍒濆绔彛: ${gl_huang}3389${gl_bai}"
		  echo -e "鎸変换鎰忛敭缁х画..."
		  read -n 1 -s -r -p ""
		  dd_xitong_bin456789
		}

		  while true; do
			root_use
			echo "閲嶈绯荤粺"
			echo "--------------------------------"
			echo -e "${gl_hong}娉ㄦ剰: ${gl_bai}閲嶈鏈夐闄╁け鑱旓紝涓嶆斁蹇冭€呮厧鐢ㄣ€傞噸瑁呴璁¤姳璐?5鍒嗛挓锛岃鎻愬墠澶囦唤鏁版嵁銆?
			echo -e "${gl_hui}鎰熻阿bin456789澶т浆鍜宭eitbogioro澶т浆鐨勮剼鏈敮鎸侊紒${gl_bai} "
			echo -e "${gl_hui}bin456789椤圭洰鍦板潃: ${gh_https_url}github.com/bin456789/reinstall${gl_bai}"
			echo -e "${gl_hui}leitbogioro椤圭洰鍦板潃: ${gh_https_url}github.com/leitbogioro/Tools${gl_bai}"
			echo "------------------------"
			echo "1. Debian 13                  2. Debian 12"
			echo "3. Debian 11                  4. Debian 10"
			echo "------------------------"
			echo "11. Ubuntu 24.04              12. Ubuntu 22.04"
			echo "13. Ubuntu 20.04              14. Ubuntu 18.04"
			echo "------------------------"
			echo "21. Rocky Linux 10            22. Rocky Linux 9"
			echo "23. Alma Linux 10             24. Alma Linux 9"
			echo "25. oracle Linux 10           26. oracle Linux 9"
			echo "27. Fedora Linux 42           28. Fedora Linux 41"
			echo "29. CentOS 10                 30. CentOS 9"
			echo "------------------------"
			echo "31. Alpine Linux              32. Arch Linux"
			echo "33. Kali Linux                34. openEuler"
			echo "35. openSUSE Tumbleweed       36. fnos椋炵墰鍏祴鐗?
			echo "------------------------"
			echo "41. Windows 11                42. Windows 10"
			echo "43. Windows 7                 44. Windows Server 2025"
			echo "45. Windows Server 2022       46. Windows Server 2019"
			echo "47. Windows 11 ARM"
			echo "------------------------"
			echo "0. 杩斿洖涓婁竴绾ч€夊崟"
			echo "------------------------"
			read -e -p "璇烽€夋嫨瑕侀噸瑁呯殑绯荤粺: " sys_choice
			case "$sys_choice" in


			  1)
				send_stats "閲嶈debian 13"
				dd_xitong_3
				bash reinstall.sh debian 13
				reboot
				exit
				;;

			  2)
				send_stats "閲嶈debian 12"
				dd_xitong_1
				bash InstallNET.sh -debian 12
				reboot
				exit
				;;
			  3)
				send_stats "閲嶈debian 11"
				dd_xitong_1
				bash InstallNET.sh -debian 11
				reboot
				exit
				;;
			  4)
				send_stats "閲嶈debian 10"
				dd_xitong_1
				bash InstallNET.sh -debian 10
				reboot
				exit
				;;
			  11)
				send_stats "閲嶈ubuntu 24.04"
				dd_xitong_1
				bash InstallNET.sh -ubuntu 24.04
				reboot
				exit
				;;
			  12)
				send_stats "閲嶈ubuntu 22.04"
				dd_xitong_1
				bash InstallNET.sh -ubuntu 22.04
				reboot
				exit
				;;
			  13)
				send_stats "閲嶈ubuntu 20.04"
				dd_xitong_1
				bash InstallNET.sh -ubuntu 20.04
				reboot
				exit
				;;
			  14)
				send_stats "閲嶈ubuntu 18.04"
				dd_xitong_1
				bash InstallNET.sh -ubuntu 18.04
				reboot
				exit
				;;


			  21)
				send_stats "閲嶈rockylinux10"
				dd_xitong_3
				bash reinstall.sh rocky
				reboot
				exit
				;;

			  22)
				send_stats "閲嶈rockylinux9"
				dd_xitong_3
				bash reinstall.sh rocky 9
				reboot
				exit
				;;

			  23)
				send_stats "閲嶈alma10"
				dd_xitong_3
				bash reinstall.sh almalinux
				reboot
				exit
				;;

			  24)
				send_stats "閲嶈alma9"
				dd_xitong_3
				bash reinstall.sh almalinux 9
				reboot
				exit
				;;

			  25)
				send_stats "閲嶈oracle10"
				dd_xitong_3
				bash reinstall.sh oracle
				reboot
				exit
				;;

			  26)
				send_stats "閲嶈oracle9"
				dd_xitong_3
				bash reinstall.sh oracle 9
				reboot
				exit
				;;

			  27)
				send_stats "閲嶈fedora42"
				dd_xitong_3
				bash reinstall.sh fedora
				reboot
				exit
				;;

			  28)
				send_stats "閲嶈fedora41"
				dd_xitong_3
				bash reinstall.sh fedora 41
				reboot
				exit
				;;

			  29)
				send_stats "閲嶈centos10"
				dd_xitong_3
				bash reinstall.sh centos 10
				reboot
				exit
				;;

			  30)
				send_stats "閲嶈centos9"
				dd_xitong_3
				bash reinstall.sh centos 9
				reboot
				exit
				;;

			  31)
				send_stats "閲嶈alpine"
				dd_xitong_1
				bash InstallNET.sh -alpine
				reboot
				exit
				;;

			  32)
				send_stats "閲嶈arch"
				dd_xitong_3
				bash reinstall.sh arch
				reboot
				exit
				;;

			  33)
				send_stats "閲嶈kali"
				dd_xitong_3
				bash reinstall.sh kali
				reboot
				exit
				;;

			  34)
				send_stats "閲嶈openeuler"
				dd_xitong_3
				bash reinstall.sh openeuler
				reboot
				exit
				;;

			  35)
				send_stats "閲嶈opensuse"
				dd_xitong_3
				bash reinstall.sh opensuse
				reboot
				exit
				;;

			  36)
				send_stats "閲嶈椋炵墰"
				dd_xitong_3
				bash reinstall.sh fnos
				reboot
				exit
				;;

			  41)
				send_stats "閲嶈windows11"
				dd_xitong_2
				bash InstallNET.sh -windows 11 -lang "cn"
				reboot
				exit
				;;

			  42)
				dd_xitong_2
				send_stats "閲嶈windows10"
				bash InstallNET.sh -windows 10 -lang "cn"
				reboot
				exit
				;;

			  43)
				send_stats "閲嶈windows7"
				dd_xitong_4
				bash reinstall.sh windows --iso="https://drive.massgrave.dev/cn_windows_7_professional_with_sp1_x64_dvd_u_677031.iso" --image-name='Windows 7 PROFESSIONAL'
				reboot
				exit
				;;

			  44)
				send_stats "閲嶈windows server 25"
				dd_xitong_2
				bash InstallNET.sh -windows 2025 -lang "cn"
				reboot
				exit
				;;

			  45)
				send_stats "閲嶈windows server 22"
				dd_xitong_2
				bash InstallNET.sh -windows 2022 -lang "cn"
				reboot
				exit
				;;

			  46)
				send_stats "閲嶈windows server 19"
				dd_xitong_2
				bash InstallNET.sh -windows 2019 -lang "cn"
				reboot
				exit
				;;

			  47)
				send_stats "閲嶈windows11 ARM"
				dd_xitong_4
				bash reinstall.sh dd --img https://r2.hotdog.eu.org/win11-arm-with-pagefile-15g.xz
				reboot
				exit
				;;

			  *)
				break
				;;
			esac
		  done
}


bbrv3() {
		  root_use
		  send_stats "bbrv3绠＄悊"

		  local cpu_arch=$(uname -m)
		  if [ "$cpu_arch" = "aarch64" ]; then
			bash <(curl -sL jhb.ovh/jb/bbrv3arm.sh)
			break_end
			linux_Settings
		  fi

		  if dpkg -l | grep -q 'linux-xanmod'; then
			while true; do
				  clear
				  local kernel_version=$(uname -r)
				  echo "鎮ㄥ凡瀹夎xanmod鐨凚BRv3鍐呮牳"
				  echo "褰撳墠鍐呮牳鐗堟湰: $kernel_version"

				  echo ""
				  echo "鍐呮牳绠＄悊"
				  echo "------------------------"
				  echo "1. 鏇存柊BBRv3鍐呮牳              2. 鍗歌浇BBRv3鍐呮牳"
				  echo "------------------------"
				  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
				  echo "------------------------"
				  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice

				  case $sub_choice in
					  1)
						apt purge -y 'linux-*xanmod1*'
						update-grub

						# wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes
						wget -qO - ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes

						# 姝ラ3锛氭坊鍔犲瓨鍌ㄥ簱
						echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list

						# version=$(wget -q https://dl.xanmod.org/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')
						local version=$(wget -q ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')

						apt update -y
						apt install -y linux-xanmod-x64v$version

						echo "XanMod鍐呮牳宸叉洿鏂般€傞噸鍚悗鐢熸晥"
						rm -f /etc/apt/sources.list.d/xanmod-release.list
						rm -f check_x86-64_psabi.sh*

						server_reboot

						  ;;
					  2)
						apt purge -y 'linux-*xanmod1*'
						update-grub
						echo "XanMod鍐呮牳宸插嵏杞姐€傞噸鍚悗鐢熸晥"
						server_reboot
						  ;;

					  *)
						  break  # 璺冲嚭寰幆锛岄€€鍑鸿彍鍗?
						  ;;

				  esac
			done
		else

		  clear
		  echo "璁剧疆BBR3鍔犻€?
		  echo "瑙嗛浠嬬粛: https://www.bilibili.com/video/BV14K421x7BS?t=0.1"
		  echo "------------------------------------------------"
		  echo "浠呮敮鎸丏ebian/Ubuntu"
		  echo "璇峰浠芥暟鎹紝灏嗕负浣犲崌绾inux鍐呮牳寮€鍚疊BR3"
		  echo "------------------------------------------------"
		  read -e -p "纭畾缁х画鍚楋紵(Y/N): " choice

		  case "$choice" in
			[Yy])
			check_disk_space 3
			if [ -r /etc/os-release ]; then
				. /etc/os-release
				if [ "$ID" != "debian" ] && [ "$ID" != "ubuntu" ]; then
					echo "褰撳墠鐜涓嶆敮鎸侊紝浠呮敮鎸丏ebian鍜孶buntu绯荤粺"
					break_end
					linux_Settings
				fi
			else
				echo "鏃犳硶纭畾鎿嶄綔绯荤粺绫诲瀷"
				break_end
				linux_Settings
			fi

			check_swap
			install wget gnupg

			# wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes
			wget -qO - ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes

			# 姝ラ3锛氭坊鍔犲瓨鍌ㄥ簱
			echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list

			# version=$(wget -q https://dl.xanmod.org/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')
			local version=$(wget -q ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')

			apt update -y
			apt install -y linux-xanmod-x64v$version

			bbr_on

			echo "XanMod鍐呮牳瀹夎骞禕BR3鍚敤鎴愬姛銆傞噸鍚悗鐢熸晥"
			rm -f /etc/apt/sources.list.d/xanmod-release.list
			rm -f check_x86-64_psabi.sh*
			server_reboot

			  ;;
			[Nn])
			  echo "宸插彇娑?
			  ;;
			*)
			  echo "鏃犳晥鐨勯€夋嫨锛岃杈撳叆 Y 鎴?N銆?
			  ;;
		  esac
		fi

}


elrepo_install() {
	# 瀵煎叆 ELRepo GPG 鍏挜
	echo "瀵煎叆 ELRepo GPG 鍏挜..."
	rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
	# 妫€娴嬬郴缁熺増鏈?
	local os_version=$(rpm -q --qf "%{VERSION}" $(rpm -qf /etc/os-release) 2>/dev/null | awk -F '.' '{print $1}')
	local os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
	# 纭繚鎴戜滑鍦ㄤ竴涓敮鎸佺殑鎿嶄綔绯荤粺涓婅繍琛?
	if [[ "$os_name" != *"Red Hat"* && "$os_name" != *"AlmaLinux"* && "$os_name" != *"Rocky"* && "$os_name" != *"Oracle"* && "$os_name" != *"CentOS"* ]]; then
		echo "涓嶆敮鎸佺殑鎿嶄綔绯荤粺锛?os_name"
		break_end
		linux_Settings
	fi
	# 鎵撳嵃妫€娴嬪埌鐨勬搷浣滅郴缁熶俊鎭?
	echo "妫€娴嬪埌鐨勬搷浣滅郴缁? $os_name $os_version"
	# 鏍规嵁绯荤粺鐗堟湰瀹夎瀵瑰簲鐨?ELRepo 浠撳簱閰嶇疆
	if [[ "$os_version" == 8 ]]; then
		echo "瀹夎 ELRepo 浠撳簱閰嶇疆 (鐗堟湰 8)..."
		yum -y install https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
	elif [[ "$os_version" == 9 ]]; then
		echo "瀹夎 ELRepo 浠撳簱閰嶇疆 (鐗堟湰 9)..."
		yum -y install https://www.elrepo.org/elrepo-release-9.el9.elrepo.noarch.rpm
	elif [[ "$os_version" == 10 ]]; then
		echo "瀹夎 ELRepo 浠撳簱閰嶇疆 (鐗堟湰 10)..."
		yum -y install https://www.elrepo.org/elrepo-release-10.el10.elrepo.noarch.rpm
	else
		echo "涓嶆敮鎸佺殑绯荤粺鐗堟湰锛?os_version"
		break_end
		linux_Settings
	fi
	# 鍚敤 ELRepo 鍐呮牳浠撳簱骞跺畨瑁呮渶鏂扮殑涓荤嚎鍐呮牳
	echo "鍚敤 ELRepo 鍐呮牳浠撳簱骞跺畨瑁呮渶鏂扮殑涓荤嚎鍐呮牳..."
	# yum -y --enablerepo=elrepo-kernel install kernel-ml
	yum --nogpgcheck -y --enablerepo=elrepo-kernel install kernel-ml
	echo "宸插畨瑁?ELRepo 浠撳簱閰嶇疆骞舵洿鏂板埌鏈€鏂颁富绾垮唴鏍搞€?
	server_reboot

}


elrepo() {
		  root_use
		  send_stats "绾㈠附鍐呮牳绠＄悊"
		  if uname -r | grep -q 'elrepo'; then
			while true; do
				  clear
				  kernel_version=$(uname -r)
				  echo "鎮ㄥ凡瀹夎elrepo鍐呮牳"
				  echo "褰撳墠鍐呮牳鐗堟湰: $kernel_version"

				  echo ""
				  echo "鍐呮牳绠＄悊"
				  echo "------------------------"
				  echo "1. 鏇存柊elrepo鍐呮牳              2. 鍗歌浇elrepo鍐呮牳"
				  echo "------------------------"
				  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
				  echo "------------------------"
				  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice

				  case $sub_choice in
					  1)
						dnf remove -y elrepo-release
						rpm -qa | grep elrepo | grep kernel | xargs rpm -e --nodeps
						elrepo_install
						send_stats "鏇存柊绾㈠附鍐呮牳"
						server_reboot

						  ;;
					  2)
						dnf remove -y elrepo-release
						rpm -qa | grep elrepo | grep kernel | xargs rpm -e --nodeps
						echo "elrepo鍐呮牳宸插嵏杞姐€傞噸鍚悗鐢熸晥"
						send_stats "鍗歌浇绾㈠附鍐呮牳"
						server_reboot

						  ;;
					  *)
						  break  # 璺冲嚭寰幆锛岄€€鍑鸿彍鍗?
						  ;;

				  esac
			done
		else

		  clear
		  echo "璇峰浠芥暟鎹紝灏嗕负浣犲崌绾inux鍐呮牳"
		  echo "瑙嗛浠嬬粛: https://www.bilibili.com/video/BV1mH4y1w7qA?t=529.2"
		  echo "------------------------------------------------"
		  echo "浠呮敮鎸佺孩甯界郴鍒楀彂琛岀増 CentOS/RedHat/Alma/Rocky/oracle "
		  echo "鍗囩骇Linux鍐呮牳鍙彁鍗囩郴缁熸€ц兘鍜屽畨鍏紝寤鸿鏈夋潯浠剁殑灏濊瘯锛岀敓浜х幆澧冭皑鎱庡崌绾э紒"
		  echo "------------------------------------------------"
		  read -e -p "纭畾缁х画鍚楋紵(Y/N): " choice

		  case "$choice" in
			[Yy])
			  check_swap
			  elrepo_install
			  send_stats "鍗囩骇绾㈠附鍐呮牳"
			  server_reboot
			  ;;
			[Nn])
			  echo "宸插彇娑?
			  ;;
			*)
			  echo "鏃犳晥鐨勯€夋嫨锛岃杈撳叆 Y 鎴?N銆?
			  ;;
		  esac
		fi

}




clamav_freshclam() {
	echo -e "${gl_kjlan}姝ｅ湪鏇存柊鐥呮瘨搴?..${gl_bai}"
	docker run --rm \
		--name clamav \
		--mount source=clam_db,target=/var/lib/clamav \
		clamav/clamav-debian:latest \
		freshclam
}

clamav_scan() {
	if [ $# -eq 0 ]; then
		echo "璇锋寚瀹氳鎵弿鐨勭洰褰曘€?
		return
	fi

	echo -e "${gl_kjlan}姝ｅ湪鎵弿鐩綍$@... ${gl_bai}"

	# 鏋勫缓 mount 鍙傛暟
	local MOUNT_PARAMS=""
	for dir in "$@"; do
		MOUNT_PARAMS+="--mount type=bind,source=${dir},target=/mnt/host${dir} "
	done

	# 鏋勫缓 clamscan 鍛戒护鍙傛暟
	local SCAN_PARAMS=""
	for dir in "$@"; do
		SCAN_PARAMS+="/mnt/host${dir} "
	done

	mkdir -p /home/docker/clamav/log/ > /dev/null 2>&1
	> /home/docker/clamav/log/scan.log > /dev/null 2>&1

	# 鎵ц Docker 鍛戒护
	docker run --rm \
		--name clamav \
		--mount source=clam_db,target=/var/lib/clamav \
		$MOUNT_PARAMS \
		-v /home/docker/clamav/log/:/var/log/clamav/ \
		clamav/clamav-debian:latest \
		clamscan -r --log=/var/log/clamav/scan.log $SCAN_PARAMS

	echo -e "${gl_lv}$@ 鎵弿瀹屾垚锛岀梾姣掓姤鍛婂瓨鏀惧湪${gl_huang}/home/docker/clamav/log/scan.log${gl_bai}"
	echo -e "${gl_lv}濡傛灉鏈夌梾姣掕鍦?{gl_huang}scan.log${gl_lv}鏂囦欢涓悳绱OUND鍏抽敭瀛楃‘璁ょ梾姣掍綅缃?${gl_bai}"

}







clamav() {
		  root_use
		  send_stats "鐥呮瘨鎵弿绠＄悊"
		  while true; do
				clear
				echo "clamav鐥呮瘨鎵弿宸ュ叿"
				echo "瑙嗛浠嬬粛: https://www.bilibili.com/video/BV1TqvZe4EQm?t=0.1"
				echo "------------------------"
				echo "鏄竴涓紑婧愮殑闃茬梾姣掕蒋浠跺伐鍏凤紝涓昏鐢ㄤ簬妫€娴嬪拰鍒犻櫎鍚勭绫诲瀷鐨勬伓鎰忚蒋浠躲€?
				echo "鍖呮嫭鐥呮瘨銆佺壒娲涗紛鏈ㄩ┈銆侀棿璋嶈蒋浠躲€佹伓鎰忚剼鏈拰鍏朵粬鏈夊杞欢銆?
				echo "------------------------"
				echo -e "${gl_lv}1. 鍏ㄧ洏鎵弿 ${gl_bai}             ${gl_huang}2. 閲嶈鐩綍鎵弿 ${gl_bai}            ${gl_kjlan} 3. 鑷畾涔夌洰褰曟壂鎻?${gl_bai}"
				echo "------------------------"
				echo "0. 杩斿洖涓婁竴绾ч€夊崟"
				echo "------------------------"
				read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice
				case $sub_choice in
					1)
					  send_stats "鍏ㄧ洏鎵弿"
					  install_docker
					  docker volume create clam_db > /dev/null 2>&1
					  clamav_freshclam
					  clamav_scan /
					  break_end

						;;
					2)
					  send_stats "閲嶈鐩綍鎵弿"
					  install_docker
					  docker volume create clam_db > /dev/null 2>&1
					  clamav_freshclam
					  clamav_scan /etc /var /usr /home /root
					  break_end
						;;
					3)
					  send_stats "鑷畾涔夌洰褰曟壂鎻?
					  read -e -p "璇疯緭鍏ヨ鎵弿鐨勭洰褰曪紝鐢ㄧ┖鏍煎垎闅旓紙渚嬪锛?etc /var /usr /home /root锛? " directories
					  install_docker
					  clamav_freshclam
					  clamav_scan $directories
					  break_end
						;;
					*)
					  break  # 璺冲嚭寰幆锛岄€€鍑鸿彍鍗?
						;;
				esac
		  done

}




# 楂樻€ц兘妯″紡浼樺寲鍑芥暟
optimize_high_performance() {
	echo -e "${gl_lv}鍒囨崲鍒?{tiaoyou_moshi}...${gl_bai}"

	echo -e "${gl_lv}浼樺寲鏂囦欢鎻忚堪绗?..${gl_bai}"
	ulimit -n 65535

	echo -e "${gl_lv}浼樺寲铏氭嫙鍐呭瓨...${gl_bai}"
	sysctl -w vm.swappiness=10 2>/dev/null
	sysctl -w vm.dirty_ratio=15 2>/dev/null
	sysctl -w vm.dirty_background_ratio=5 2>/dev/null
	sysctl -w vm.overcommit_memory=1 2>/dev/null
	sysctl -w vm.min_free_kbytes=65536 2>/dev/null

	echo -e "${gl_lv}浼樺寲缃戠粶璁剧疆...${gl_bai}"
	sysctl -w net.core.rmem_max=16777216 2>/dev/null
	sysctl -w net.core.wmem_max=16777216 2>/dev/null
	sysctl -w net.core.netdev_max_backlog=250000 2>/dev/null
	sysctl -w net.core.somaxconn=4096 2>/dev/null
	sysctl -w net.ipv4.tcp_rmem='4096 87380 16777216' 2>/dev/null
	sysctl -w net.ipv4.tcp_wmem='4096 65536 16777216' 2>/dev/null
	sysctl -w net.ipv4.tcp_congestion_control=bbr 2>/dev/null
	sysctl -w net.ipv4.tcp_max_syn_backlog=8192 2>/dev/null
	sysctl -w net.ipv4.tcp_tw_reuse=1 2>/dev/null
	sysctl -w net.ipv4.ip_local_port_range='1024 65535' 2>/dev/null

	echo -e "${gl_lv}浼樺寲缂撳瓨绠＄悊...${gl_bai}"
	sysctl -w vm.vfs_cache_pressure=50 2>/dev/null

	echo -e "${gl_lv}浼樺寲CPU璁剧疆...${gl_bai}"
	sysctl -w kernel.sched_autogroup_enabled=0 2>/dev/null

	echo -e "${gl_lv}鍏朵粬浼樺寲...${gl_bai}"
	# 绂佺敤閫忔槑澶ч〉闈紝鍑忓皯寤惰繜
	echo never > /sys/kernel/mm/transparent_hugepage/enabled
	# 绂佺敤 NUMA balancing
	sysctl -w kernel.numa_balancing=0 2>/dev/null


}

# 鍧囪　妯″紡浼樺寲鍑芥暟
optimize_balanced() {
	echo -e "${gl_lv}鍒囨崲鍒板潎琛℃ā寮?..${gl_bai}"

	echo -e "${gl_lv}浼樺寲鏂囦欢鎻忚堪绗?..${gl_bai}"
	ulimit -n 32768

	echo -e "${gl_lv}浼樺寲铏氭嫙鍐呭瓨...${gl_bai}"
	sysctl -w vm.swappiness=30 2>/dev/null
	sysctl -w vm.dirty_ratio=20 2>/dev/null
	sysctl -w vm.dirty_background_ratio=10 2>/dev/null
	sysctl -w vm.overcommit_memory=0 2>/dev/null
	sysctl -w vm.min_free_kbytes=32768 2>/dev/null

	echo -e "${gl_lv}浼樺寲缃戠粶璁剧疆...${gl_bai}"
	sysctl -w net.core.rmem_max=8388608 2>/dev/null
	sysctl -w net.core.wmem_max=8388608 2>/dev/null
	sysctl -w net.core.netdev_max_backlog=125000 2>/dev/null
	sysctl -w net.core.somaxconn=2048 2>/dev/null
	sysctl -w net.ipv4.tcp_rmem='4096 87380 8388608' 2>/dev/null
	sysctl -w net.ipv4.tcp_wmem='4096 32768 8388608' 2>/dev/null
	sysctl -w net.ipv4.tcp_congestion_control=bbr 2>/dev/null
	sysctl -w net.ipv4.tcp_max_syn_backlog=4096 2>/dev/null
	sysctl -w net.ipv4.tcp_tw_reuse=1 2>/dev/null
	sysctl -w net.ipv4.ip_local_port_range='1024 49151' 2>/dev/null

	echo -e "${gl_lv}浼樺寲缂撳瓨绠＄悊...${gl_bai}"
	sysctl -w vm.vfs_cache_pressure=75 2>/dev/null

	echo -e "${gl_lv}浼樺寲CPU璁剧疆...${gl_bai}"
	sysctl -w kernel.sched_autogroup_enabled=1 2>/dev/null

	echo -e "${gl_lv}鍏朵粬浼樺寲...${gl_bai}"
	# 杩樺師閫忔槑澶ч〉闈?
	echo always > /sys/kernel/mm/transparent_hugepage/enabled
	# 杩樺師 NUMA balancing
	sysctl -w kernel.numa_balancing=1 2>/dev/null


}

# 杩樺師榛樿璁剧疆鍑芥暟
restore_defaults() {
	echo -e "${gl_lv}杩樺師鍒伴粯璁よ缃?..${gl_bai}"

	echo -e "${gl_lv}杩樺師鏂囦欢鎻忚堪绗?..${gl_bai}"
	ulimit -n 1024

	echo -e "${gl_lv}杩樺師铏氭嫙鍐呭瓨...${gl_bai}"
	sysctl -w vm.swappiness=60 2>/dev/null
	sysctl -w vm.dirty_ratio=20 2>/dev/null
	sysctl -w vm.dirty_background_ratio=10 2>/dev/null
	sysctl -w vm.overcommit_memory=0 2>/dev/null
	sysctl -w vm.min_free_kbytes=16384 2>/dev/null

	echo -e "${gl_lv}杩樺師缃戠粶璁剧疆...${gl_bai}"
	sysctl -w net.core.rmem_max=212992 2>/dev/null
	sysctl -w net.core.wmem_max=212992 2>/dev/null
	sysctl -w net.core.netdev_max_backlog=1000 2>/dev/null
	sysctl -w net.core.somaxconn=128 2>/dev/null
	sysctl -w net.ipv4.tcp_rmem='4096 87380 6291456' 2>/dev/null
	sysctl -w net.ipv4.tcp_wmem='4096 16384 4194304' 2>/dev/null
	sysctl -w net.ipv4.tcp_congestion_control=cubic 2>/dev/null
	sysctl -w net.ipv4.tcp_max_syn_backlog=2048 2>/dev/null
	sysctl -w net.ipv4.tcp_tw_reuse=0 2>/dev/null
	sysctl -w net.ipv4.ip_local_port_range='32768 60999' 2>/dev/null

	echo -e "${gl_lv}杩樺師缂撳瓨绠＄悊...${gl_bai}"
	sysctl -w vm.vfs_cache_pressure=100 2>/dev/null

	echo -e "${gl_lv}杩樺師CPU璁剧疆...${gl_bai}"
	sysctl -w kernel.sched_autogroup_enabled=1 2>/dev/null

	echo -e "${gl_lv}杩樺師鍏朵粬浼樺寲...${gl_bai}"
	# 杩樺師閫忔槑澶ч〉闈?
	echo always > /sys/kernel/mm/transparent_hugepage/enabled
	# 杩樺師 NUMA balancing
	sysctl -w kernel.numa_balancing=1 2>/dev/null

}



# 缃戠珯鎼缓浼樺寲鍑芥暟
optimize_web_server() {
	echo -e "${gl_lv}鍒囨崲鍒扮綉绔欐惌寤轰紭鍖栨ā寮?..${gl_bai}"

	echo -e "${gl_lv}浼樺寲鏂囦欢鎻忚堪绗?..${gl_bai}"
	ulimit -n 65535

	echo -e "${gl_lv}浼樺寲铏氭嫙鍐呭瓨...${gl_bai}"
	sysctl -w vm.swappiness=10 2>/dev/null
	sysctl -w vm.dirty_ratio=20 2>/dev/null
	sysctl -w vm.dirty_background_ratio=10 2>/dev/null
	sysctl -w vm.overcommit_memory=1 2>/dev/null
	sysctl -w vm.min_free_kbytes=65536 2>/dev/null

	echo -e "${gl_lv}浼樺寲缃戠粶璁剧疆...${gl_bai}"
	sysctl -w net.core.rmem_max=16777216 2>/dev/null
	sysctl -w net.core.wmem_max=16777216 2>/dev/null
	sysctl -w net.core.netdev_max_backlog=5000 2>/dev/null
	sysctl -w net.core.somaxconn=4096 2>/dev/null
	sysctl -w net.ipv4.tcp_rmem='4096 87380 16777216' 2>/dev/null
	sysctl -w net.ipv4.tcp_wmem='4096 65536 16777216' 2>/dev/null
	sysctl -w net.ipv4.tcp_congestion_control=bbr 2>/dev/null
	sysctl -w net.ipv4.tcp_max_syn_backlog=8192 2>/dev/null
	sysctl -w net.ipv4.tcp_tw_reuse=1 2>/dev/null
	sysctl -w net.ipv4.ip_local_port_range='1024 65535' 2>/dev/null

	echo -e "${gl_lv}浼樺寲缂撳瓨绠＄悊...${gl_bai}"
	sysctl -w vm.vfs_cache_pressure=50 2>/dev/null

	echo -e "${gl_lv}浼樺寲CPU璁剧疆...${gl_bai}"
	sysctl -w kernel.sched_autogroup_enabled=0 2>/dev/null

	echo -e "${gl_lv}鍏朵粬浼樺寲...${gl_bai}"
	# 绂佺敤閫忔槑澶ч〉闈紝鍑忓皯寤惰繜
	echo never > /sys/kernel/mm/transparent_hugepage/enabled
	# 绂佺敤 NUMA balancing
	sysctl -w kernel.numa_balancing=0 2>/dev/null


}


Kernel_optimize() {
	root_use
	while true; do
	  clear
	  send_stats "Linux鍐呮牳璋冧紭绠＄悊"
	  echo "Linux绯荤粺鍐呮牳鍙傛暟浼樺寲"
	  echo "瑙嗛浠嬬粛: https://www.bilibili.com/video/BV1Kb421J7yg?t=0.1"
	  echo "------------------------------------------------"
	  echo "鎻愪緵澶氱绯荤粺鍙傛暟璋冧紭妯″紡锛岀敤鎴峰彲浠ユ牴鎹嚜韬娇鐢ㄥ満鏅繘琛岄€夋嫨鍒囨崲銆?
	  echo -e "${gl_huang}鎻愮ず: ${gl_bai}鐢熶骇鐜璇疯皑鎱庝娇鐢紒"
	  echo "--------------------"
	  echo "1. 楂樻€ц兘浼樺寲妯″紡锛?    鏈€澶у寲绯荤粺鎬ц兘锛屼紭鍖栨枃浠舵弿杩扮銆佽櫄鎷熷唴瀛樸€佺綉缁滆缃€佺紦瀛樼鐞嗗拰CPU璁剧疆銆?
	  echo "2. 鍧囪　浼樺寲妯″紡锛?      鍦ㄦ€ц兘涓庤祫婧愭秷鑰椾箣闂村彇寰楀钩琛★紝閫傚悎鏃ュ父浣跨敤銆?
	  echo "3. 缃戠珯浼樺寲妯″紡锛?      閽堝缃戠珯鏈嶅姟鍣ㄨ繘琛屼紭鍖栵紝鎻愰珮骞跺彂杩炴帴澶勭悊鑳藉姏銆佸搷搴旈€熷害鍜屾暣浣撴€ц兘銆?
	  echo "4. 鐩存挱浼樺寲妯″紡锛?      閽堝鐩存挱鎺ㄦ祦鐨勭壒娈婇渶姹傝繘琛屼紭鍖栵紝鍑忓皯寤惰繜锛屾彁楂樹紶杈撴€ц兘銆?
	  echo "5. 娓告垙鏈嶄紭鍖栨ā寮忥細     閽堝娓告垙鏈嶅姟鍣ㄨ繘琛屼紭鍖栵紝鎻愰珮骞跺彂澶勭悊鑳藉姏鍜屽搷搴旈€熷害銆?
	  echo "6. 杩樺師榛樿璁剧疆锛?      灏嗙郴缁熻缃繕鍘熶负榛樿閰嶇疆銆?
	  echo "--------------------"
	  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
	  echo "--------------------"
	  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice
	  case $sub_choice in
		  1)
			  cd ~
			  clear
			  local tiaoyou_moshi="楂樻€ц兘浼樺寲妯″紡"
			  optimize_high_performance
			  send_stats "楂樻€ц兘妯″紡浼樺寲"
			  ;;
		  2)
			  cd ~
			  clear
			  optimize_balanced
			  send_stats "鍧囪　妯″紡浼樺寲"
			  ;;
		  3)
			  cd ~
			  clear
			  optimize_web_server
			  send_stats "缃戠珯浼樺寲妯″紡"
			  ;;
		  4)
			  cd ~
			  clear
			  local tiaoyou_moshi="鐩存挱浼樺寲妯″紡"
			  optimize_high_performance
			  send_stats "鐩存挱鎺ㄦ祦浼樺寲"
			  ;;
		  5)
			  cd ~
			  clear
			  local tiaoyou_moshi="娓告垙鏈嶄紭鍖栨ā寮?
			  optimize_high_performance
			  send_stats "娓告垙鏈嶄紭鍖?
			  ;;
		  6)
			  cd ~
			  clear
			  restore_defaults
			  send_stats "杩樺師榛樿璁剧疆"
			  ;;
		  *)
			  break
			  ;;
	  esac
	  break_end
	done
}





update_locale() {
	local lang=$1
	local locale_file=$2

	if [ -f /etc/os-release ]; then
		. /etc/os-release
		case $ID in
			debian|ubuntu|kali)
				install locales
				sed -i "s/^\s*#\?\s*${locale_file}/${locale_file}/" /etc/locale.gen
				locale-gen
				echo "LANG=${lang}" > /etc/default/locale
				export LANG=${lang}
				echo -e "${gl_lv}绯荤粺璇█宸茬粡淇敼涓? $lang 閲嶆柊杩炴帴SSH鐢熸晥銆?{gl_bai}"
				hash -r
				break_end

				;;
			centos|rhel|almalinux|rocky|fedora)
				install glibc-langpack-zh
				localectl set-locale LANG=${lang}
				echo "LANG=${lang}" | tee /etc/locale.conf
				echo -e "${gl_lv}绯荤粺璇█宸茬粡淇敼涓? $lang 閲嶆柊杩炴帴SSH鐢熸晥銆?{gl_bai}"
				hash -r
				break_end
				;;
			*)
				echo "涓嶆敮鎸佺殑绯荤粺: $ID"
				break_end
				;;
		esac
	else
		echo "涓嶆敮鎸佺殑绯荤粺锛屾棤娉曡瘑鍒郴缁熺被鍨嬨€?
		break_end
	fi
}




linux_language() {
root_use
send_stats "鍒囨崲绯荤粺璇█"
while true; do
  clear
  echo "褰撳墠绯荤粺璇█: $LANG"
  echo "------------------------"
  echo "1. 鑻辨枃          2. 绠€浣撲腑鏂?         3. 绻佷綋涓枃"
  echo "------------------------"
  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
  echo "------------------------"
  read -e -p "杈撳叆浣犵殑閫夋嫨: " choice

  case $choice in
	  1)
		  update_locale "en_US.UTF-8" "en_US.UTF-8"
		  send_stats "鍒囨崲鍒拌嫳鏂?
		  ;;
	  2)
		  update_locale "zh_CN.UTF-8" "zh_CN.UTF-8"
		  send_stats "鍒囨崲鍒扮畝浣撲腑鏂?
		  ;;
	  3)
		  update_locale "zh_TW.UTF-8" "zh_TW.UTF-8"
		  send_stats "鍒囨崲鍒扮箒浣撲腑鏂?
		  ;;
	  *)
		  break
		  ;;
  esac
done
}



shell_bianse_profile() {

if command -v dnf &>/dev/null || command -v yum &>/dev/null; then
	sed -i '/^PS1=/d' ~/.bashrc
	echo "${bianse}" >> ~/.bashrc
	# source ~/.bashrc
else
	sed -i '/^PS1=/d' ~/.profile
	echo "${bianse}" >> ~/.profile
	# source ~/.profile
fi
echo -e "${gl_lv}鍙樻洿瀹屾垚銆傞噸鏂拌繛鎺SH鍚庡彲鏌ョ湅鍙樺寲锛?{gl_bai}"

hash -r
break_end

}



shell_bianse() {
  root_use
  send_stats "鍛戒护琛岀編鍖栧伐鍏?
  while true; do
	clear
	echo "鍛戒护琛岀編鍖栧伐鍏?
	echo "------------------------"
	echo -e "1. \033[1;32mroot \033[1;34mlocalhost \033[1;31m~ \033[0m${gl_bai}#"
	echo -e "2. \033[1;35mroot \033[1;36mlocalhost \033[1;33m~ \033[0m${gl_bai}#"
	echo -e "3. \033[1;31mroot \033[1;32mlocalhost \033[1;34m~ \033[0m${gl_bai}#"
	echo -e "4. \033[1;36mroot \033[1;33mlocalhost \033[1;37m~ \033[0m${gl_bai}#"
	echo -e "5. \033[1;37mroot \033[1;31mlocalhost \033[1;32m~ \033[0m${gl_bai}#"
	echo -e "6. \033[1;33mroot \033[1;34mlocalhost \033[1;35m~ \033[0m${gl_bai}#"
	echo -e "7. root localhost ~ #"
	echo "------------------------"
	echo "0. 杩斿洖涓婁竴绾ч€夊崟"
	echo "------------------------"
	read -e -p "杈撳叆浣犵殑閫夋嫨: " choice

	case $choice in
	  1)
		local bianse="PS1='\[\033[1;32m\]\u\[\033[0m\]@\[\033[1;34m\]\h\[\033[0m\] \[\033[1;31m\]\w\[\033[0m\] # '"
		shell_bianse_profile

		;;
	  2)
		local bianse="PS1='\[\033[1;35m\]\u\[\033[0m\]@\[\033[1;36m\]\h\[\033[0m\] \[\033[1;33m\]\w\[\033[0m\] # '"
		shell_bianse_profile
		;;
	  3)
		local bianse="PS1='\[\033[1;31m\]\u\[\033[0m\]@\[\033[1;32m\]\h\[\033[0m\] \[\033[1;34m\]\w\[\033[0m\] # '"
		shell_bianse_profile
		;;
	  4)
		local bianse="PS1='\[\033[1;36m\]\u\[\033[0m\]@\[\033[1;33m\]\h\[\033[0m\] \[\033[1;37m\]\w\[\033[0m\] # '"
		shell_bianse_profile
		;;
	  5)
		local bianse="PS1='\[\033[1;37m\]\u\[\033[0m\]@\[\033[1;31m\]\h\[\033[0m\] \[\033[1;32m\]\w\[\033[0m\] # '"
		shell_bianse_profile
		;;
	  6)
		local bianse="PS1='\[\033[1;33m\]\u\[\033[0m\]@\[\033[1;34m\]\h\[\033[0m\] \[\033[1;35m\]\w\[\033[0m\] # '"
		shell_bianse_profile
		;;
	  7)
		local bianse=""
		shell_bianse_profile
		;;
	  *)
		break
		;;
	esac

  done
}




linux_trash() {
  root_use
  send_stats "绯荤粺鍥炴敹绔?

  local bashrc_profile="/root/.bashrc"
  local TRASH_DIR="$HOME/.local/share/Trash/files"

  while true; do

	local trash_status
	if ! grep -q "trash-put" "$bashrc_profile"; then
		trash_status="${gl_hui}鏈惎鐢?{gl_bai}"
	else
		trash_status="${gl_lv}宸插惎鐢?{gl_bai}"
	fi

	clear
	echo -e "褰撳墠鍥炴敹绔?${trash_status}"
	echo -e "鍚敤鍚巖m鍒犻櫎鐨勬枃浠跺厛杩涘叆鍥炴敹绔欙紝闃叉璇垹閲嶈鏂囦欢锛?
	echo "------------------------------------------------"
	ls -l --color=auto "$TRASH_DIR" 2>/dev/null || echo "鍥炴敹绔欎负绌?
	echo "------------------------"
	echo "1. 鍚敤鍥炴敹绔?         2. 鍏抽棴鍥炴敹绔?
	echo "3. 杩樺師鍐呭            4. 娓呯┖鍥炴敹绔?
	echo "------------------------"
	echo "0. 杩斿洖涓婁竴绾ч€夊崟"
	echo "------------------------"
	read -e -p "杈撳叆浣犵殑閫夋嫨: " choice

	case $choice in
	  1)
		install trash-cli
		sed -i '/alias rm/d' "$bashrc_profile"
		echo "alias rm='trash-put'" >> "$bashrc_profile"
		source "$bashrc_profile"
		echo "鍥炴敹绔欏凡鍚敤锛屽垹闄ょ殑鏂囦欢灏嗙Щ鑷冲洖鏀剁珯銆?
		sleep 2
		;;
	  2)
		remove trash-cli
		sed -i '/alias rm/d' "$bashrc_profile"
		echo "alias rm='rm -i'" >> "$bashrc_profile"
		source "$bashrc_profile"
		echo "鍥炴敹绔欏凡鍏抽棴锛屾枃浠跺皢鐩存帴鍒犻櫎銆?
		sleep 2
		;;
	  3)
		read -e -p "杈撳叆瑕佽繕鍘熺殑鏂囦欢鍚? " file_to_restore
		if [ -e "$TRASH_DIR/$file_to_restore" ]; then
		  mv "$TRASH_DIR/$file_to_restore" "$HOME/"
		  echo "$file_to_restore 宸茶繕鍘熷埌涓荤洰褰曘€?
		else
		  echo "鏂囦欢涓嶅瓨鍦ㄣ€?
		fi
		;;
	  4)
		read -e -p "纭娓呯┖鍥炴敹绔欙紵[y/n]: " confirm
		if [[ "$confirm" == "y" ]]; then
		  trash-empty
		  echo "鍥炴敹绔欏凡娓呯┖銆?
		fi
		;;
	  *)
		break
		;;
	esac
  done
}

linux_fav() {
send_stats "鍛戒护鏀惰棌澶?
bash <(curl -l -s ${gh_proxy}raw.githubusercontent.com/byJoey/cmdbox/refs/heads/main/install.sh)
}

# 鍒涘缓澶囦唤
create_backup() {
	send_stats "鍒涘缓澶囦唤"
	local TIMESTAMP=$(date +"%Y%m%d%H%M%S")

	# 鎻愮ず鐢ㄦ埛杈撳叆澶囦唤鐩綍
	echo "鍒涘缓澶囦唤绀轰緥锛?
	echo "  - 澶囦唤鍗曚釜鐩綍: /var/www"
	echo "  - 澶囦唤澶氫釜鐩綍: /etc /home /var/log"
	echo "  - 鐩存帴鍥炶溅灏嗕娇鐢ㄩ粯璁ょ洰褰?(/etc /usr /home)"
	read -e -p "璇疯緭鍏ヨ澶囦唤鐨勭洰褰曪紙澶氫釜鐩綍鐢ㄧ┖鏍煎垎闅旓紝鐩存帴鍥炶溅鍒欎娇鐢ㄩ粯璁ょ洰褰曪級锛? input

	# 濡傛灉鐢ㄦ埛娌℃湁杈撳叆鐩綍锛屽垯浣跨敤榛樿鐩綍
	if [ -z "$input" ]; then
		BACKUP_PATHS=(
			"/etc"              # 閰嶇疆鏂囦欢鍜岃蒋浠跺寘閰嶇疆
			"/usr"              # 宸插畨瑁呯殑杞欢鏂囦欢
			"/home"             # 鐢ㄦ埛鏁版嵁
		)
	else
		# 灏嗙敤鎴疯緭鍏ョ殑鐩綍鎸夌┖鏍煎垎闅旀垚鏁扮粍
		IFS=' ' read -r -a BACKUP_PATHS <<< "$input"
	fi

	# 鐢熸垚澶囦唤鏂囦欢鍓嶇紑
	local PREFIX=""
	for path in "${BACKUP_PATHS[@]}"; do
		# 鎻愬彇鐩綍鍚嶇О骞跺幓闄ゆ枩鏉?
		dir_name=$(basename "$path")
		PREFIX+="${dir_name}_"
	done

	# 鍘婚櫎鏈€鍚庝竴涓笅鍒掔嚎
	local PREFIX=${PREFIX%_}

	# 鐢熸垚澶囦唤鏂囦欢鍚?
	local BACKUP_NAME="${PREFIX}_$TIMESTAMP.tar.gz"

	# 鎵撳嵃鐢ㄦ埛閫夋嫨鐨勭洰褰?
	echo "鎮ㄩ€夋嫨鐨勫浠界洰褰曚负锛?
	for path in "${BACKUP_PATHS[@]}"; do
		echo "- $path"
	done

	# 鍒涘缓澶囦唤
	echo "姝ｅ湪鍒涘缓澶囦唤 $BACKUP_NAME..."
	install tar
	tar -czvf "$BACKUP_DIR/$BACKUP_NAME" "${BACKUP_PATHS[@]}"

	# 妫€鏌ュ懡浠ゆ槸鍚︽垚鍔?
	if [ $? -eq 0 ]; then
		echo "澶囦唤鍒涘缓鎴愬姛: $BACKUP_DIR/$BACKUP_NAME"
	else
		echo "澶囦唤鍒涘缓澶辫触锛?
		exit 1
	fi
}

# 鎭㈠澶囦唤
restore_backup() {
	send_stats "鎭㈠澶囦唤"
	# 閫夋嫨瑕佹仮澶嶇殑澶囦唤
	read -e -p "璇疯緭鍏ヨ鎭㈠鐨勫浠芥枃浠跺悕: " BACKUP_NAME

	# 妫€鏌ュ浠芥枃浠舵槸鍚﹀瓨鍦?
	if [ ! -f "$BACKUP_DIR/$BACKUP_NAME" ]; then
		echo "澶囦唤鏂囦欢涓嶅瓨鍦紒"
		exit 1
	fi

	echo "姝ｅ湪鎭㈠澶囦唤 $BACKUP_NAME..."
	tar -xzvf "$BACKUP_DIR/$BACKUP_NAME" -C /

	if [ $? -eq 0 ]; then
		echo "澶囦唤鎭㈠鎴愬姛锛?
	else
		echo "澶囦唤鎭㈠澶辫触锛?
		exit 1
	fi
}

# 鍒楀嚭澶囦唤
list_backups() {
	echo "鍙敤鐨勫浠斤細"
	ls -1 "$BACKUP_DIR"
}

# 鍒犻櫎澶囦唤
delete_backup() {
	send_stats "鍒犻櫎澶囦唤"

	read -e -p "璇疯緭鍏ヨ鍒犻櫎鐨勫浠芥枃浠跺悕: " BACKUP_NAME

	# 妫€鏌ュ浠芥枃浠舵槸鍚﹀瓨鍦?
	if [ ! -f "$BACKUP_DIR/$BACKUP_NAME" ]; then
		echo "澶囦唤鏂囦欢涓嶅瓨鍦紒"
		exit 1
	fi

	# 鍒犻櫎澶囦唤
	rm -f "$BACKUP_DIR/$BACKUP_NAME"

	if [ $? -eq 0 ]; then
		echo "澶囦唤鍒犻櫎鎴愬姛锛?
	else
		echo "澶囦唤鍒犻櫎澶辫触锛?
		exit 1
	fi
}

# 澶囦唤涓昏彍鍗?
linux_backup() {
	BACKUP_DIR="/backups"
	mkdir -p "$BACKUP_DIR"
	while true; do
		clear
		send_stats "绯荤粺澶囦唤鍔熻兘"
		echo "绯荤粺澶囦唤鍔熻兘"
		echo "------------------------"
		list_backups
		echo "------------------------"
		echo "1. 鍒涘缓澶囦唤        2. 鎭㈠澶囦唤        3. 鍒犻櫎澶囦唤"
		echo "------------------------"
		echo "0. 杩斿洖涓婁竴绾ч€夊崟"
		echo "------------------------"
		read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " choice
		case $choice in
			1) create_backup ;;
			2) restore_backup ;;
			3) delete_backup ;;
			*) break ;;
		esac
		read -e -p "鎸夊洖杞﹂敭缁х画..."
	done
}









# 鏄剧ず杩炴帴鍒楄〃
list_connections() {
	echo "宸蹭繚瀛樼殑杩炴帴:"
	echo "------------------------"
	cat "$CONFIG_FILE" | awk -F'|' '{print NR " - " $1 " (" $2 ")"}'
	echo "------------------------"
}


# 娣诲姞鏂拌繛鎺?
add_connection() {
	send_stats "娣诲姞鏂拌繛鎺?
	echo "鍒涘缓鏂拌繛鎺ョず渚嬶細"
	echo "  - 杩炴帴鍚嶇О: my_server"
	echo "  - IP鍦板潃: 192.168.1.100"
	echo "  - 鐢ㄦ埛鍚? root"
	echo "  - 绔彛: 22"
	echo "------------------------"
	read -e -p "璇疯緭鍏ヨ繛鎺ュ悕绉? " name
	read -e -p "璇疯緭鍏P鍦板潃: " ip
	read -e -p "璇疯緭鍏ョ敤鎴峰悕 (榛樿: root): " user
	local user=${user:-root}  # 濡傛灉鐢ㄦ埛鏈緭鍏ワ紝鍒欎娇鐢ㄩ粯璁ゅ€?root
	read -e -p "璇疯緭鍏ョ鍙ｅ彿 (榛樿: 22): " port
	local port=${port:-22}  # 濡傛灉鐢ㄦ埛鏈緭鍏ワ紝鍒欎娇鐢ㄩ粯璁ゅ€?22

	echo "璇烽€夋嫨韬唤楠岃瘉鏂瑰紡:"
	echo "1. 瀵嗙爜"
	echo "2. 瀵嗛挜"
	read -e -p "璇疯緭鍏ラ€夋嫨 (1/2): " auth_choice

	case $auth_choice in
		1)
			read -s -p "璇疯緭鍏ュ瘑鐮? " password_or_key
			echo  # 鎹㈣
			;;
		2)
			echo "璇风矘璐村瘑閽ュ唴瀹?(绮樿创瀹屾垚鍚庢寜涓ゆ鍥炶溅)锛?
			local password_or_key=""
			while IFS= read -r line; do
				# 濡傛灉杈撳叆涓虹┖琛屼笖瀵嗛挜鍐呭宸茬粡鍖呭惈浜嗗紑澶达紝鍒欑粨鏉熻緭鍏?
				if [[ -z "$line" && "$password_or_key" == *"-----BEGIN"* ]]; then
					break
				fi
				# 濡傛灉鏄涓€琛屾垨宸茬粡寮€濮嬭緭鍏ュ瘑閽ュ唴瀹癸紝鍒欑户缁坊鍔?
				if [[ -n "$line" || "$password_or_key" == *"-----BEGIN"* ]]; then
					local password_or_key+="${line}"$'\n'
				fi
			done

			# 妫€鏌ユ槸鍚︽槸瀵嗛挜鍐呭
			if [[ "$password_or_key" == *"-----BEGIN"* && "$password_or_key" == *"PRIVATE KEY-----"* ]]; then
				local key_file="$KEY_DIR/$name.key"
				echo -n "$password_or_key" > "$key_file"
				chmod 600 "$key_file"
				local password_or_key="$key_file"
			fi
			;;
		*)
			echo "鏃犳晥鐨勯€夋嫨锛?
			return
			;;
	esac

	echo "$name|$ip|$user|$port|$password_or_key" >> "$CONFIG_FILE"
	echo "杩炴帴宸蹭繚瀛?"
}



# 鍒犻櫎杩炴帴
delete_connection() {
	send_stats "鍒犻櫎杩炴帴"
	read -e -p "璇疯緭鍏ヨ鍒犻櫎鐨勮繛鎺ョ紪鍙? " num

	local connection=$(sed -n "${num}p" "$CONFIG_FILE")
	if [[ -z "$connection" ]]; then
		echo "閿欒锛氭湭鎵惧埌瀵瑰簲鐨勮繛鎺ャ€?
		return
	fi

	IFS='|' read -r name ip user port password_or_key <<< "$connection"

	# 濡傛灉杩炴帴浣跨敤鐨勬槸瀵嗛挜鏂囦欢锛屽垯鍒犻櫎璇ュ瘑閽ユ枃浠?
	if [[ "$password_or_key" == "$KEY_DIR"* ]]; then
		rm -f "$password_or_key"
	fi

	sed -i "${num}d" "$CONFIG_FILE"
	echo "杩炴帴宸插垹闄?"
}

# 浣跨敤杩炴帴
use_connection() {
	send_stats "浣跨敤杩炴帴"
	read -e -p "璇疯緭鍏ヨ浣跨敤鐨勮繛鎺ョ紪鍙? " num

	local connection=$(sed -n "${num}p" "$CONFIG_FILE")
	if [[ -z "$connection" ]]; then
		echo "閿欒锛氭湭鎵惧埌瀵瑰簲鐨勮繛鎺ャ€?
		return
	fi

	IFS='|' read -r name ip user port password_or_key <<< "$connection"

	echo "姝ｅ湪杩炴帴鍒?$name ($ip)..."
	if [[ -f "$password_or_key" ]]; then
		# 浣跨敤瀵嗛挜杩炴帴
		ssh -o StrictHostKeyChecking=no -i "$password_or_key" -p "$port" "$user@$ip"
		if [[ $? -ne 0 ]]; then
			echo "杩炴帴澶辫触锛佽妫€鏌ヤ互涓嬪唴瀹癸細"
			echo "1. 瀵嗛挜鏂囦欢璺緞鏄惁姝ｇ‘锛?password_or_key"
			echo "2. 瀵嗛挜鏂囦欢鏉冮檺鏄惁姝ｇ‘锛堝簲涓?600锛夈€?
			echo "3. 鐩爣鏈嶅姟鍣ㄦ槸鍚﹀厑璁镐娇鐢ㄥ瘑閽ョ櫥褰曘€?
		fi
	else
		# 浣跨敤瀵嗙爜杩炴帴
		if ! command -v sshpass &> /dev/null; then
			echo "閿欒锛氭湭瀹夎 sshpass锛岃鍏堝畨瑁?sshpass銆?
			echo "瀹夎鏂规硶锛?
			echo "  - Ubuntu/Debian: apt install sshpass"
			echo "  - CentOS/RHEL: yum install sshpass"
			return
		fi
		sshpass -p "$password_or_key" ssh -o StrictHostKeyChecking=no -p "$port" "$user@$ip"
		if [[ $? -ne 0 ]]; then
			echo "杩炴帴澶辫触锛佽妫€鏌ヤ互涓嬪唴瀹癸細"
			echo "1. 鐢ㄦ埛鍚嶅拰瀵嗙爜鏄惁姝ｇ‘銆?
			echo "2. 鐩爣鏈嶅姟鍣ㄦ槸鍚﹀厑璁稿瘑鐮佺櫥褰曘€?
			echo "3. 鐩爣鏈嶅姟鍣ㄧ殑 SSH 鏈嶅姟鏄惁姝ｅ父杩愯銆?
		fi
	fi
}


ssh_manager() {
	send_stats "ssh杩滅▼杩炴帴宸ュ叿"

	CONFIG_FILE="$HOME/.ssh_connections"
	KEY_DIR="$HOME/.ssh/ssh_manager_keys"

	# 妫€鏌ラ厤缃枃浠跺拰瀵嗛挜鐩綍鏄惁瀛樺湪锛屽鏋滀笉瀛樺湪鍒欏垱寤?
	if [[ ! -f "$CONFIG_FILE" ]]; then
		touch "$CONFIG_FILE"
	fi

	if [[ ! -d "$KEY_DIR" ]]; then
		mkdir -p "$KEY_DIR"
		chmod 700 "$KEY_DIR"
	fi

	while true; do
		clear
		echo "SSH 杩滅▼杩炴帴宸ュ叿"
		echo "鍙互閫氳繃SSH杩炴帴鍒板叾浠朙inux绯荤粺涓?
		echo "------------------------"
		list_connections
		echo "1. 鍒涘缓鏂拌繛鎺?       2. 浣跨敤杩炴帴        3. 鍒犻櫎杩炴帴"
		echo "------------------------"
		echo "0. 杩斿洖涓婁竴绾ч€夊崟"
		echo "------------------------"
		read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " choice
		case $choice in
			1) add_connection ;;
			2) use_connection ;;
			3) delete_connection ;;
			0) break ;;
			*) echo "鏃犳晥鐨勯€夋嫨锛岃閲嶈瘯銆? ;;
		esac
	done
}












# 鍒楀嚭鍙敤鐨勭‖鐩樺垎鍖?
list_partitions() {
	echo "鍙敤鐨勭‖鐩樺垎鍖猴細"
	lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT | grep -v "sr\|loop"
}


# 鎸佷箙鍖栨寕杞藉垎鍖?
mount_partition() {
	send_stats "鎸傝浇鍒嗗尯"
	read -e -p "璇疯緭鍏ヨ鎸傝浇鐨勫垎鍖哄悕绉帮紙渚嬪 sda1锛? " PARTITION

	DEVICE="/dev/$PARTITION"
	MOUNT_POINT="/mnt/$PARTITION"

	# 妫€鏌ュ垎鍖烘槸鍚﹀瓨鍦?
	if ! lsblk -no NAME | grep -qw "$PARTITION"; then
		echo "鍒嗗尯涓嶅瓨鍦紒"
		return 1
	fi

	# 妫€鏌ユ槸鍚﹀凡鎸傝浇
	if mount | grep -qw "$DEVICE"; then
		echo "鍒嗗尯宸茬粡鎸傝浇锛?
		return 1
	fi

	# 鑾峰彇 UUID
	UUID=$(blkid -s UUID -o value "$DEVICE")
	if [ -z "$UUID" ]; then
		echo "鏃犳硶鑾峰彇 UUID锛?
		return 1
	fi

	# 鑾峰彇鏂囦欢绯荤粺绫诲瀷
	FSTYPE=$(blkid -s TYPE -o value "$DEVICE")
	if [ -z "$FSTYPE" ]; then
		echo "鏃犳硶鑾峰彇鏂囦欢绯荤粺绫诲瀷锛?
		return 1
	fi

	# 鍒涘缓鎸傝浇鐐?
	mkdir -p "$MOUNT_POINT"

	# 鎸傝浇
	if ! mount "$DEVICE" "$MOUNT_POINT"; then
		echo "鍒嗗尯鎸傝浇澶辫触锛?
		rmdir "$MOUNT_POINT"
		return 1
	fi

	echo "鍒嗗尯宸叉垚鍔熸寕杞藉埌 $MOUNT_POINT"

	# 妫€鏌?/etc/fstab 鏄惁宸茬粡瀛樺湪 UUID 鎴栨寕杞界偣
	if grep -qE "UUID=$UUID|[[:space:]]$MOUNT_POINT[[:space:]]" /etc/fstab; then
		echo "/etc/fstab 涓凡瀛樺湪璇ュ垎鍖鸿褰曪紝璺宠繃鍐欏叆"
		return 0
	fi

	# 鍐欏叆 /etc/fstab
	echo "UUID=$UUID $MOUNT_POINT $FSTYPE defaults,nofail 0 2" >> /etc/fstab

	echo "宸插啓鍏?/etc/fstab锛屽疄鐜版寔涔呭寲鎸傝浇"
}


# 鍗歌浇鍒嗗尯
unmount_partition() {
	send_stats "鍗歌浇鍒嗗尯"
	read -e -p "璇疯緭鍏ヨ鍗歌浇鐨勫垎鍖哄悕绉帮紙渚嬪 sda1锛? " PARTITION

	# 妫€鏌ュ垎鍖烘槸鍚﹀凡缁忔寕杞?
	MOUNT_POINT=$(lsblk -o MOUNTPOINT | grep -w "$PARTITION")
	if [ -z "$MOUNT_POINT" ]; then
		echo "鍒嗗尯鏈寕杞斤紒"
		return
	fi

	# 鍗歌浇鍒嗗尯
	umount "/dev/$PARTITION"

	if [ $? -eq 0 ]; then
		echo "鍒嗗尯鍗歌浇鎴愬姛: $MOUNT_POINT"
		rmdir "$MOUNT_POINT"
	else
		echo "鍒嗗尯鍗歌浇澶辫触锛?
	fi
}

# 鍒楀嚭宸叉寕杞界殑鍒嗗尯
list_mounted_partitions() {
	echo "宸叉寕杞界殑鍒嗗尯锛?
	df -h | grep -v "tmpfs\|udev\|overlay"
}

# 鏍煎紡鍖栧垎鍖?
format_partition() {
	send_stats "鏍煎紡鍖栧垎鍖?
	read -e -p "璇疯緭鍏ヨ鏍煎紡鍖栫殑鍒嗗尯鍚嶇О锛堜緥濡?sda1锛? " PARTITION

	# 妫€鏌ュ垎鍖烘槸鍚﹀瓨鍦?
	if ! lsblk -o NAME | grep -w "$PARTITION" > /dev/null; then
		echo "鍒嗗尯涓嶅瓨鍦紒"
		return
	fi

	# 妫€鏌ュ垎鍖烘槸鍚﹀凡缁忔寕杞?
	if lsblk -o MOUNTPOINT | grep -w "$PARTITION" > /dev/null; then
		echo "鍒嗗尯宸茬粡鎸傝浇锛岃鍏堝嵏杞斤紒"
		return
	fi

	# 閫夋嫨鏂囦欢绯荤粺绫诲瀷
	echo "璇烽€夋嫨鏂囦欢绯荤粺绫诲瀷锛?
	echo "1. ext4"
	echo "2. xfs"
	echo "3. ntfs"
	echo "4. vfat"
	read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " FS_CHOICE

	case $FS_CHOICE in
		1) FS_TYPE="ext4" ;;
		2) FS_TYPE="xfs" ;;
		3) FS_TYPE="ntfs" ;;
		4) FS_TYPE="vfat" ;;
		*) echo "鏃犳晥鐨勯€夋嫨锛?; return ;;
	esac

	# 纭鏍煎紡鍖?
	read -e -p "纭鏍煎紡鍖栧垎鍖?/dev/$PARTITION 涓?$FS_TYPE 鍚楋紵(y/n): " CONFIRM
	if [ "$CONFIRM" != "y" ]; then
		echo "鎿嶄綔宸插彇娑堛€?
		return
	fi

	# 鏍煎紡鍖栧垎鍖?
	echo "姝ｅ湪鏍煎紡鍖栧垎鍖?/dev/$PARTITION 涓?$FS_TYPE ..."
	mkfs.$FS_TYPE "/dev/$PARTITION"

	if [ $? -eq 0 ]; then
		echo "鍒嗗尯鏍煎紡鍖栨垚鍔燂紒"
	else
		echo "鍒嗗尯鏍煎紡鍖栧け璐ワ紒"
	fi
}

# 妫€鏌ュ垎鍖虹姸鎬?
check_partition() {
	send_stats "妫€鏌ュ垎鍖虹姸鎬?
	read -e -p "璇疯緭鍏ヨ妫€鏌ョ殑鍒嗗尯鍚嶇О锛堜緥濡?sda1锛? " PARTITION

	# 妫€鏌ュ垎鍖烘槸鍚﹀瓨鍦?
	if ! lsblk -o NAME | grep -w "$PARTITION" > /dev/null; then
		echo "鍒嗗尯涓嶅瓨鍦紒"
		return
	fi

	# 妫€鏌ュ垎鍖虹姸鎬?
	echo "妫€鏌ュ垎鍖?/dev/$PARTITION 鐨勭姸鎬侊細"
	fsck "/dev/$PARTITION"
}

# 涓昏彍鍗?
disk_manager() {
	send_stats "纭洏绠＄悊鍔熻兘"
	while true; do
		clear
		echo "纭洏鍒嗗尯绠＄悊"
		echo -e "${gl_huang}璇ュ姛鑳藉唴閮ㄦ祴璇曢樁娈碉紝璇峰嬁鍦ㄧ敓浜х幆澧冧娇鐢ㄣ€?{gl_bai}"
		echo "------------------------"
		list_partitions
		echo "------------------------"
		echo "1. 鎸傝浇鍒嗗尯        2. 鍗歌浇鍒嗗尯        3. 鏌ョ湅宸叉寕杞藉垎鍖?
		echo "4. 鏍煎紡鍖栧垎鍖?     5. 妫€鏌ュ垎鍖虹姸鎬?
		echo "------------------------"
		echo "0. 杩斿洖涓婁竴绾ч€夊崟"
		echo "------------------------"
		read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " choice
		case $choice in
			1) mount_partition ;;
			2) unmount_partition ;;
			3) list_mounted_partitions ;;
			4) format_partition ;;
			5) check_partition ;;
			*) break ;;
		esac
		read -e -p "鎸夊洖杞﹂敭缁х画..."
	done
}




# 鏄剧ず浠诲姟鍒楄〃
list_tasks() {
	echo "宸蹭繚瀛樼殑鍚屾浠诲姟:"
	echo "---------------------------------"
	awk -F'|' '{print NR " - " $1 " ( " $2 " -> " $3":"$4 " )"}' "$CONFIG_FILE"
	echo "---------------------------------"
}

# 娣诲姞鏂颁换鍔?
add_task() {
	send_stats "娣诲姞鏂板悓姝ヤ换鍔?
	echo "鍒涘缓鏂板悓姝ヤ换鍔＄ず渚嬶細"
	echo "  - 浠诲姟鍚嶇О: backup_www"
	echo "  - 鏈湴鐩綍: /var/www"
	echo "  - 杩滅▼鍦板潃: user@192.168.1.100"
	echo "  - 杩滅▼鐩綍: /backup/www"
	echo "  - 绔彛鍙?(榛樿 22)"
	echo "---------------------------------"
	read -e -p "璇疯緭鍏ヤ换鍔″悕绉? " name
	read -e -p "璇疯緭鍏ユ湰鍦扮洰褰? " local_path
	read -e -p "璇疯緭鍏ヨ繙绋嬬洰褰? " remote_path
	read -e -p "璇疯緭鍏ヨ繙绋嬬敤鎴稝IP: " remote
	read -e -p "璇疯緭鍏?SSH 绔彛 (榛樿 22): " port
	port=${port:-22}

	echo "璇烽€夋嫨韬唤楠岃瘉鏂瑰紡:"
	echo "1. 瀵嗙爜"
	echo "2. 瀵嗛挜"
	read -e -p "璇烽€夋嫨 (1/2): " auth_choice

	case $auth_choice in
		1)
			read -s -p "璇疯緭鍏ュ瘑鐮? " password_or_key
			echo  # 鎹㈣
			auth_method="password"
			;;
		2)
			echo "璇风矘璐村瘑閽ュ唴瀹?(绮樿创瀹屾垚鍚庢寜涓ゆ鍥炶溅)锛?
			local password_or_key=""
			while IFS= read -r line; do
				# 濡傛灉杈撳叆涓虹┖琛屼笖瀵嗛挜鍐呭宸茬粡鍖呭惈浜嗗紑澶达紝鍒欑粨鏉熻緭鍏?
				if [[ -z "$line" && "$password_or_key" == *"-----BEGIN"* ]]; then
					break
				fi
				# 濡傛灉鏄涓€琛屾垨宸茬粡寮€濮嬭緭鍏ュ瘑閽ュ唴瀹癸紝鍒欑户缁坊鍔?
				if [[ -n "$line" || "$password_or_key" == *"-----BEGIN"* ]]; then
					password_or_key+="${line}"$'\n'
				fi
			done

			# 妫€鏌ユ槸鍚︽槸瀵嗛挜鍐呭
			if [[ "$password_or_key" == *"-----BEGIN"* && "$password_or_key" == *"PRIVATE KEY-----"* ]]; then
				local key_file="$KEY_DIR/${name}_sync.key"
				echo -n "$password_or_key" > "$key_file"
				chmod 600 "$key_file"
				password_or_key="$key_file"
				auth_method="key"
			else
				echo "鏃犳晥鐨勫瘑閽ュ唴瀹癸紒"
				return
			fi
			;;
		*)
			echo "鏃犳晥鐨勯€夋嫨锛?
			return
			;;
	esac

	echo "璇烽€夋嫨鍚屾妯″紡:"
	echo "1. 鏍囧噯妯″紡 (-avz)"
	echo "2. 鍒犻櫎鐩爣鏂囦欢 (-avz --delete)"
	read -e -p "璇烽€夋嫨 (1/2): " mode
	case $mode in
		1) options="-avz" ;;
		2) options="-avz --delete" ;;
		*) echo "鏃犳晥閫夋嫨锛屼娇鐢ㄩ粯璁?-avz"; options="-avz" ;;
	esac

	echo "$name|$local_path|$remote|$remote_path|$port|$options|$auth_method|$password_or_key" >> "$CONFIG_FILE"

	install rsync rsync

	echo "浠诲姟宸蹭繚瀛?"
}

# 鍒犻櫎浠诲姟
delete_task() {
	send_stats "鍒犻櫎鍚屾浠诲姟"
	read -e -p "璇疯緭鍏ヨ鍒犻櫎鐨勪换鍔＄紪鍙? " num

	local task=$(sed -n "${num}p" "$CONFIG_FILE")
	if [[ -z "$task" ]]; then
		echo "閿欒锛氭湭鎵惧埌瀵瑰簲鐨勪换鍔°€?
		return
	fi

	IFS='|' read -r name local_path remote remote_path port options auth_method password_or_key <<< "$task"

	# 濡傛灉浠诲姟浣跨敤鐨勬槸瀵嗛挜鏂囦欢锛屽垯鍒犻櫎璇ュ瘑閽ユ枃浠?
	if [[ "$auth_method" == "key" && "$password_or_key" == "$KEY_DIR"* ]]; then
		rm -f "$password_or_key"
	fi

	sed -i "${num}d" "$CONFIG_FILE"
	echo "浠诲姟宸插垹闄?"
}


run_task() {
	send_stats "鎵ц鍚屾浠诲姟"

	CONFIG_FILE="$HOME/.rsync_tasks"
	CRON_FILE="$HOME/.rsync_cron"

	# 瑙ｆ瀽鍙傛暟
	local direction="push"  # 榛樿鏄帹閫佸埌杩滅
	local num

	if [[ "$1" == "push" || "$1" == "pull" ]]; then
		direction="$1"
		num="$2"
	else
		num="$1"
	fi

	# 濡傛灉娌℃湁浼犲叆浠诲姟缂栧彿锛屾彁绀虹敤鎴疯緭鍏?
	if [[ -z "$num" ]]; then
		read -e -p "璇疯緭鍏ヨ鎵ц鐨勪换鍔＄紪鍙? " num
	fi

	local task=$(sed -n "${num}p" "$CONFIG_FILE")
	if [[ -z "$task" ]]; then
		echo "閿欒: 鏈壘鍒拌浠诲姟!"
		return
	fi

	IFS='|' read -r name local_path remote remote_path port options auth_method password_or_key <<< "$task"

	# 鏍规嵁鍚屾鏂瑰悜璋冩暣婧愬拰鐩爣璺緞
	if [[ "$direction" == "pull" ]]; then
		echo "姝ｅ湪鎷夊彇鍚屾鍒版湰鍦? $remote:$local_path -> $remote_path"
		source="$remote:$local_path"
		destination="$remote_path"
	else
		echo "姝ｅ湪鎺ㄩ€佸悓姝ュ埌杩滅: $local_path -> $remote:$remote_path"
		source="$local_path"
		destination="$remote:$remote_path"
	fi

	# 娣诲姞 SSH 杩炴帴閫氱敤鍙傛暟
	local ssh_options="-p $port -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

	if [[ "$auth_method" == "password" ]]; then
		if ! command -v sshpass &> /dev/null; then
			echo "閿欒锛氭湭瀹夎 sshpass锛岃鍏堝畨瑁?sshpass銆?
			echo "瀹夎鏂规硶锛?
			echo "  - Ubuntu/Debian: apt install sshpass"
			echo "  - CentOS/RHEL: yum install sshpass"
			return
		fi
		sshpass -p "$password_or_key" rsync $options -e "ssh $ssh_options" "$source" "$destination"
	else
		# 妫€鏌ュ瘑閽ユ枃浠舵槸鍚﹀瓨鍦ㄥ拰鏉冮檺鏄惁姝ｇ‘
		if [[ ! -f "$password_or_key" ]]; then
			echo "閿欒锛氬瘑閽ユ枃浠朵笉瀛樺湪锛?password_or_key"
			return
		fi

		if [[ "$(stat -c %a "$password_or_key")" != "600" ]]; then
			echo "璀﹀憡锛氬瘑閽ユ枃浠舵潈闄愪笉姝ｇ‘锛屾鍦ㄤ慨澶?.."
			chmod 600 "$password_or_key"
		fi

		rsync $options -e "ssh -i $password_or_key $ssh_options" "$source" "$destination"
	fi

	if [[ $? -eq 0 ]]; then
		echo "鍚屾瀹屾垚!"
	else
		echo "鍚屾澶辫触! 璇锋鏌ヤ互涓嬪唴瀹癸細"
		echo "1. 缃戠粶杩炴帴鏄惁姝ｅ父"
		echo "2. 杩滅▼涓绘満鏄惁鍙闂?
		echo "3. 璁よ瘉淇℃伅鏄惁姝ｇ‘"
		echo "4. 鏈湴鍜岃繙绋嬬洰褰曟槸鍚︽湁姝ｇ‘鐨勮闂潈闄?
	fi
}


# 鍒涘缓瀹氭椂浠诲姟
schedule_task() {
	send_stats "娣诲姞鍚屾瀹氭椂浠诲姟"

	read -e -p "璇疯緭鍏ヨ瀹氭椂鍚屾鐨勪换鍔＄紪鍙? " num
	if ! [[ "$num" =~ ^[0-9]+$ ]]; then
		echo "閿欒: 璇疯緭鍏ユ湁鏁堢殑浠诲姟缂栧彿锛?
		return
	fi

	echo "璇烽€夋嫨瀹氭椂鎵ц闂撮殧锛?
	echo "1) 姣忓皬鏃舵墽琛屼竴娆?
	echo "2) 姣忓ぉ鎵ц涓€娆?
	echo "3) 姣忓懆鎵ц涓€娆?
	read -e -p "璇疯緭鍏ラ€夐」 (1/2/3): " interval

	local random_minute=$(shuf -i 0-59 -n 1)  # 鐢熸垚 0-59 涔嬮棿鐨勯殢鏈哄垎閽熸暟
	local cron_time=""
	case "$interval" in
		1) cron_time="$random_minute * * * *" ;;  # 姣忓皬鏃讹紝闅忔満鍒嗛挓鎵ц
		2) cron_time="$random_minute 0 * * *" ;;  # 姣忓ぉ锛岄殢鏈哄垎閽熸墽琛?
		3) cron_time="$random_minute 0 * * 1" ;;  # 姣忓懆锛岄殢鏈哄垎閽熸墽琛?
		*) echo "閿欒: 璇疯緭鍏ユ湁鏁堢殑閫夐」锛? ; return ;;
	esac

	local cron_job="$cron_time k rsync_run $num"
	local cron_job="$cron_time k rsync_run $num"

	# 妫€鏌ユ槸鍚﹀凡瀛樺湪鐩稿悓浠诲姟
	if crontab -l | grep -q "k rsync_run $num"; then
		echo "閿欒: 璇ヤ换鍔＄殑瀹氭椂鍚屾宸插瓨鍦紒"
		return
	fi

	# 鍒涘缓鍒扮敤鎴风殑 crontab
	(crontab -l 2>/dev/null; echo "$cron_job") | crontab -
	echo "瀹氭椂浠诲姟宸插垱寤? $cron_job"
}

# 鏌ョ湅瀹氭椂浠诲姟
view_tasks() {
	echo "褰撳墠鐨勫畾鏃朵换鍔?"
	echo "---------------------------------"
	crontab -l | grep "k rsync_run"
	echo "---------------------------------"
}

# 鍒犻櫎瀹氭椂浠诲姟
delete_task_schedule() {
	send_stats "鍒犻櫎鍚屾瀹氭椂浠诲姟"
	read -e -p "璇疯緭鍏ヨ鍒犻櫎鐨勪换鍔＄紪鍙? " num
	if ! [[ "$num" =~ ^[0-9]+$ ]]; then
		echo "閿欒: 璇疯緭鍏ユ湁鏁堢殑浠诲姟缂栧彿锛?
		return
	fi

	crontab -l | grep -v "k rsync_run $num" | crontab -
	echo "宸插垹闄や换鍔＄紪鍙?$num 鐨勫畾鏃朵换鍔?
}


# 浠诲姟绠＄悊涓昏彍鍗?
rsync_manager() {
	CONFIG_FILE="$HOME/.rsync_tasks"
	CRON_FILE="$HOME/.rsync_cron"

	while true; do
		clear
		echo "Rsync 杩滅▼鍚屾宸ュ叿"
		echo "杩滅▼鐩綍涔嬮棿鍚屾锛屾敮鎸佸閲忓悓姝ワ紝楂樻晥绋冲畾銆?
		echo "---------------------------------"
		list_tasks
		echo
		view_tasks
		echo
		echo "1. 鍒涘缓鏂颁换鍔?                2. 鍒犻櫎浠诲姟"
		echo "3. 鎵ц鏈湴鍚屾鍒拌繙绔?        4. 鎵ц杩滅鍚屾鍒版湰鍦?
		echo "5. 鍒涘缓瀹氭椂浠诲姟               6. 鍒犻櫎瀹氭椂浠诲姟"
		echo "---------------------------------"
		echo "0. 杩斿洖涓婁竴绾ч€夊崟"
		echo "---------------------------------"
		read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " choice
		case $choice in
			1) add_task ;;
			2) delete_task ;;
			3) run_task push;;
			4) run_task pull;;
			5) schedule_task ;;
			6) delete_task_schedule ;;
			0) break ;;
			*) echo "鏃犳晥鐨勯€夋嫨锛岃閲嶈瘯銆? ;;
		esac
		read -e -p "鎸夊洖杞﹂敭缁х画..."
	done
}









linux_info() {



	clear
	echo -e "${gl_kjlan}姝ｅ湪鏌ヨ绯荤粺淇℃伅鈥︹€?{gl_bai}"
	send_stats "绯荤粺淇℃伅鏌ヨ"

	ip_address

	local cpu_info=$(lscpu | awk -F': +' '/Model name:/ {print $2; exit}')

	local cpu_usage_percent=$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else printf "%.0f\n", (($2+$4-u1) * 100 / (t-t1))}' \
		<(grep 'cpu ' /proc/stat) <(sleep 1; grep 'cpu ' /proc/stat))

	local cpu_cores=$(nproc)

	local cpu_freq=$(cat /proc/cpuinfo | grep "MHz" | head -n 1 | awk '{printf "%.1f GHz\n", $4/1000}')

	local mem_info=$(free -b | awk 'NR==2{printf "%.2f/%.2fM (%.2f%%)", $3/1024/1024, $2/1024/1024, $3*100/$2}')

	local disk_info=$(df -h | awk '$NF=="/"{printf "%s/%s (%s)", $3, $2, $5}')

	local ipinfo=$(curl -s ipinfo.io)
	local country=$(echo "$ipinfo" | grep 'country' | awk -F': ' '{print $2}' | tr -d '",')
	local city=$(echo "$ipinfo" | grep 'city' | awk -F': ' '{print $2}' | tr -d '",')
	local isp_info=$(echo "$ipinfo" | grep 'org' | awk -F': ' '{print $2}' | tr -d '",')

	local load=$(uptime | awk '{print $(NF-2), $(NF-1), $NF}')
	local dns_addresses=$(awk '/^nameserver/{printf "%s ", $2} END {print ""}' /etc/resolv.conf)


	local cpu_arch=$(uname -m)

	local hostname=$(uname -n)

	local kernel_version=$(uname -r)

	local congestion_algorithm=$(sysctl -n net.ipv4.tcp_congestion_control)
	local queue_algorithm=$(sysctl -n net.core.default_qdisc)

	local os_info=$(grep PRETTY_NAME /etc/os-release | cut -d '=' -f2 | tr -d '"')

	output_status

	local current_time=$(date "+%Y-%m-%d %I:%M %p")


	local swap_info=$(free -m | awk 'NR==3{used=$3; total=$2; if (total == 0) {percentage=0} else {percentage=used*100/total}; printf "%dM/%dM (%d%%)", used, total, percentage}')

	local runtime=$(cat /proc/uptime | awk -F. '{run_days=int($1 / 86400);run_hours=int(($1 % 86400) / 3600);run_minutes=int(($1 % 3600) / 60); if (run_days > 0) printf("%d澶?", run_days); if (run_hours > 0) printf("%d鏃?", run_hours); printf("%d鍒哱n", run_minutes)}')

	local timezone=$(current_timezone)

	local tcp_count=$(ss -t | wc -l)
	local udp_count=$(ss -u | wc -l)

	clear
	echo -e "绯荤粺淇℃伅鏌ヨ"
	echo -e "${gl_kjlan}-------------"
	echo -e "${gl_kjlan}涓绘満鍚?         ${gl_bai}$hostname"
	echo -e "${gl_kjlan}绯荤粺鐗堟湰:       ${gl_bai}$os_info"
	echo -e "${gl_kjlan}Linux鐗堟湰:      ${gl_bai}$kernel_version"
	echo -e "${gl_kjlan}-------------"
	echo -e "${gl_kjlan}CPU鏋舵瀯:        ${gl_bai}$cpu_arch"
	echo -e "${gl_kjlan}CPU鍨嬪彿:        ${gl_bai}$cpu_info"
	echo -e "${gl_kjlan}CPU鏍稿績鏁?      ${gl_bai}$cpu_cores"
	echo -e "${gl_kjlan}CPU棰戠巼:        ${gl_bai}$cpu_freq"
	echo -e "${gl_kjlan}-------------"
	echo -e "${gl_kjlan}CPU鍗犵敤:        ${gl_bai}$cpu_usage_percent%"
	echo -e "${gl_kjlan}绯荤粺璐熻浇:       ${gl_bai}$load"
	echo -e "${gl_kjlan}TCP|UDP杩炴帴鏁?  ${gl_bai}$tcp_count|$udp_count"
	echo -e "${gl_kjlan}鐗╃悊鍐呭瓨:       ${gl_bai}$mem_info"
	echo -e "${gl_kjlan}铏氭嫙鍐呭瓨:       ${gl_bai}$swap_info"
	echo -e "${gl_kjlan}纭洏鍗犵敤:       ${gl_bai}$disk_info"
	echo -e "${gl_kjlan}-------------"
	echo -e "${gl_kjlan}鎬绘帴鏀?         ${gl_bai}$rx"
	echo -e "${gl_kjlan}鎬诲彂閫?         ${gl_bai}$tx"
	echo -e "${gl_kjlan}-------------"
	echo -e "${gl_kjlan}缃戠粶绠楁硶:       ${gl_bai}$congestion_algorithm $queue_algorithm"
	echo -e "${gl_kjlan}-------------"
	echo -e "${gl_kjlan}杩愯惀鍟?         ${gl_bai}$isp_info"
	if [ -n "$ipv4_address" ]; then
		echo -e "${gl_kjlan}IPv4鍦板潃:       ${gl_bai}$ipv4_address"
	fi

	if [ -n "$ipv6_address" ]; then
		echo -e "${gl_kjlan}IPv6鍦板潃:       ${gl_bai}$ipv6_address"
	fi
	echo -e "${gl_kjlan}DNS鍦板潃:        ${gl_bai}$dns_addresses"
	echo -e "${gl_kjlan}鍦扮悊浣嶇疆:       ${gl_bai}$country $city"
	echo -e "${gl_kjlan}绯荤粺鏃堕棿:       ${gl_bai}$timezone $current_time"
	echo -e "${gl_kjlan}-------------"
	echo -e "${gl_kjlan}杩愯鏃堕暱:       ${gl_bai}$runtime"
	echo



}



linux_tools() {

  while true; do
	  clear
	  # send_stats "鍩虹宸ュ叿"
	  echo -e "鍩虹宸ュ叿"

	  tools=(
		curl wget sudo socat htop iftop unzip tar tmux ffmpeg
		btop ranger ncdu fzf cmatrix sl bastet nsnake ninvaders
		vim nano git
	  )

	  if command -v apt >/dev/null 2>&1; then
		PM="apt"
	  elif command -v dnf >/dev/null 2>&1; then
		PM="dnf"
	  elif command -v yum >/dev/null 2>&1; then
		PM="yum"
	  elif command -v pacman >/dev/null 2>&1; then
		PM="pacman"
	  elif command -v apk >/dev/null 2>&1; then
		PM="apk"
	  elif command -v zypper >/dev/null 2>&1; then
		PM="zypper"
	  elif command -v opkg >/dev/null 2>&1; then
		PM="opkg"
	  elif command -v pkg >/dev/null 2>&1; then
		PM="pkg"
	  else
		echo "鉂?鏈瘑鍒殑鍖呯鐞嗗櫒"
		exit 1
	  fi

	  echo "馃摝 浣跨敤鍖呯鐞嗗櫒: $PM"
	  echo -e "${gl_kjlan}------------------------${gl_bai}"

	  for ((i=0; i<${#tools[@]}; i+=2)); do
		# 宸﹀垪
		if command -v "${tools[i]}" >/dev/null 2>&1; then
		  left=$(printf "鉁?%-12s 宸插畨瑁? "${tools[i]}")
		else
		  left=$(printf "鉂?%-12s 鏈畨瑁? "${tools[i]}")
		fi

		# 鍙冲垪锛堥槻姝㈡暟缁勮秺鐣岋級
		if [[ -n "${tools[i+1]}" ]]; then
		  if command -v "${tools[i+1]}" >/dev/null 2>&1; then
			right=$(printf "鉁?%-12s 宸插畨瑁? "${tools[i+1]}")
		  else
			right=$(printf "鉂?%-12s 鏈畨瑁? "${tools[i+1]}")
		  fi
		  printf "%-42s %s\n" "$left" "$right"
		else
		  printf "%s\n" "$left"
		fi
	  done

	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}1.   ${gl_bai}curl 涓嬭浇宸ュ叿 ${gl_huang}鈽?{gl_bai}                   ${gl_kjlan}2.   ${gl_bai}wget 涓嬭浇宸ュ叿 ${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}3.   ${gl_bai}sudo 瓒呯骇绠＄悊鏉冮檺宸ュ叿             ${gl_kjlan}4.   ${gl_bai}socat 閫氫俊杩炴帴宸ュ叿"
	  echo -e "${gl_kjlan}5.   ${gl_bai}htop 绯荤粺鐩戞帶宸ュ叿                 ${gl_kjlan}6.   ${gl_bai}iftop 缃戠粶娴侀噺鐩戞帶宸ュ叿"
	  echo -e "${gl_kjlan}7.   ${gl_bai}unzip ZIP鍘嬬缉瑙ｅ帇宸ュ叿             ${gl_kjlan}8.   ${gl_bai}tar GZ鍘嬬缉瑙ｅ帇宸ュ叿"
	  echo -e "${gl_kjlan}9.   ${gl_bai}tmux 澶氳矾鍚庡彴杩愯宸ュ叿             ${gl_kjlan}10.  ${gl_bai}ffmpeg 瑙嗛缂栫爜鐩存挱鎺ㄦ祦宸ュ叿"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}11.  ${gl_bai}btop 鐜颁唬鍖栫洃鎺у伐鍏?${gl_huang}鈽?{gl_bai}             ${gl_kjlan}12.  ${gl_bai}ranger 鏂囦欢绠＄悊宸ュ叿"
	  echo -e "${gl_kjlan}13.  ${gl_bai}ncdu 纾佺洏鍗犵敤鏌ョ湅宸ュ叿             ${gl_kjlan}14.  ${gl_bai}fzf 鍏ㄥ眬鎼滅储宸ュ叿"
	  echo -e "${gl_kjlan}15.  ${gl_bai}vim 鏂囨湰缂栬緫鍣?                   ${gl_kjlan}16.  ${gl_bai}nano 鏂囨湰缂栬緫鍣?${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}17.  ${gl_bai}git 鐗堟湰鎺у埗绯荤粺                  ${gl_kjlan}18.  ${gl_bai}opencode AI缂栫▼鍔╂墜 ${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}21.  ${gl_bai}榛戝甯濆浗灞忎繚                      ${gl_kjlan}22.  ${gl_bai}璺戠伀杞﹀睆淇?
	  echo -e "${gl_kjlan}26.  ${gl_bai}淇勭綏鏂柟鍧楀皬娓告垙                  ${gl_kjlan}27.  ${gl_bai}璐悆铔囧皬娓告垙"
	  echo -e "${gl_kjlan}28.  ${gl_bai}澶┖鍏ヤ镜鑰呭皬娓告垙"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}31.  ${gl_bai}鍏ㄩ儴瀹夎                          ${gl_kjlan}32.  ${gl_bai}鍏ㄩ儴瀹夎锛堜笉鍚睆淇濆拰娓告垙锛?{gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}33.  ${gl_bai}鍏ㄩ儴鍗歌浇"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}41.  ${gl_bai}瀹夎鎸囧畾宸ュ叿                      ${gl_kjlan}42.  ${gl_bai}鍗歌浇鎸囧畾宸ュ叿"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}0.   ${gl_bai}杩斿洖涓昏彍鍗?
	  echo -e "${gl_kjlan}------------------------${gl_bai}"
	  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice

	  case $sub_choice in
		  1)
			  clear
			  install curl
			  clear
			  echo "宸ュ叿宸插畨瑁咃紝浣跨敤鏂规硶濡備笅锛?
			  curl --help
			  send_stats "瀹夎curl"
			  ;;
		  2)
			  clear
			  install wget
			  clear
			  echo "宸ュ叿宸插畨瑁咃紝浣跨敤鏂规硶濡備笅锛?
			  wget --help
			  send_stats "瀹夎wget"
			  ;;
			3)
			  clear
			  install sudo
			  clear
			  echo "宸ュ叿宸插畨瑁咃紝浣跨敤鏂规硶濡備笅锛?
			  sudo --help
			  send_stats "瀹夎sudo"
			  ;;
			4)
			  clear
			  install socat
			  clear
			  echo "宸ュ叿宸插畨瑁咃紝浣跨敤鏂规硶濡備笅锛?
			  socat -h
			  send_stats "瀹夎socat"
			  ;;
			5)
			  clear
			  install htop
			  clear
			  htop
			  send_stats "瀹夎htop"
			  ;;
			6)
			  clear
			  install iftop
			  clear
			  iftop
			  send_stats "瀹夎iftop"
			  ;;
			7)
			  clear
			  install unzip
			  clear
			  echo "宸ュ叿宸插畨瑁咃紝浣跨敤鏂规硶濡備笅锛?
			  unzip
			  send_stats "瀹夎unzip"
			  ;;
			8)
			  clear
			  install tar
			  clear
			  echo "宸ュ叿宸插畨瑁咃紝浣跨敤鏂规硶濡備笅锛?
			  tar --help
			  send_stats "瀹夎tar"
			  ;;
			9)
			  clear
			  install tmux
			  clear
			  echo "宸ュ叿宸插畨瑁咃紝浣跨敤鏂规硶濡備笅锛?
			  tmux --help
			  send_stats "瀹夎tmux"
			  ;;
			10)
			  clear
			  install ffmpeg
			  clear
			  echo "宸ュ叿宸插畨瑁咃紝浣跨敤鏂规硶濡備笅锛?
			  ffmpeg --help
			  send_stats "瀹夎ffmpeg"
			  ;;

			11)
			  clear
			  install btop
			  clear
			  btop
			  send_stats "瀹夎btop"
			  ;;
			12)
			  clear
			  install ranger
			  cd /
			  clear
			  ranger
			  cd ~
			  send_stats "瀹夎ranger"
			  ;;
			13)
			  clear
			  install ncdu
			  cd /
			  clear
			  ncdu
			  cd ~
			  send_stats "瀹夎ncdu"
			  ;;
			14)
			  clear
			  install fzf
			  cd /
			  clear
			  fzf
			  cd ~
			  send_stats "瀹夎fzf"
			  ;;
			15)
			  clear
			  install vim
			  cd /
			  clear
			  vim -h
			  cd ~
			  send_stats "瀹夎vim"
			  ;;
			16)
			  clear
			  install nano
			  cd /
			  clear
			  nano -h
			  cd ~
			  send_stats "瀹夎nano"
			  ;;


			17)
			  clear
			  install git
			  cd /
			  clear
			  git --help
			  cd ~
			  send_stats "瀹夎git"
			  ;;

			18)
			  clear
			  cd ~
			  curl -fsSL https://opencode.ai/install | bash
			  source ~/.bashrc
			  source ~/.profile
			  opencode
			  send_stats "瀹夎opencode"
			  ;;


			21)
			  clear
			  install cmatrix
			  clear
			  cmatrix
			  send_stats "瀹夎cmatrix"
			  ;;
			22)
			  clear
			  install sl
			  clear
			  sl
			  send_stats "瀹夎sl"
			  ;;
			26)
			  clear
			  install bastet
			  clear
			  bastet
			  send_stats "瀹夎bastet"
			  ;;
			27)
			  clear
			  install nsnake
			  clear
			  nsnake
			  send_stats "瀹夎nsnake"
			  ;;

			28)
			  clear
			  install ninvaders
			  clear
			  ninvaders
			  send_stats "瀹夎ninvaders"
			  ;;

		  31)
			  clear
			  send_stats "鍏ㄩ儴瀹夎"
			  install curl wget sudo socat htop iftop unzip tar tmux ffmpeg btop ranger ncdu fzf cmatrix sl bastet nsnake ninvaders vim nano git
			  ;;

		  32)
			  clear
			  send_stats "鍏ㄩ儴瀹夎锛堜笉鍚父鎴忓拰灞忎繚锛?
			  install curl wget sudo socat htop iftop unzip tar tmux ffmpeg btop ranger ncdu fzf vim nano git
			  ;;


		  33)
			  clear
			  send_stats "鍏ㄩ儴鍗歌浇"
			  remove htop iftop tmux ffmpeg btop ranger ncdu fzf cmatrix sl bastet nsnake ninvaders vim nano git
			  opencode uninstall
			  rm -rf ~/.opencode
			  ;;

		  41)
			  clear
			  read -e -p "璇疯緭鍏ュ畨瑁呯殑宸ュ叿鍚嶏紙wget curl sudo htop锛? " installname
			  install $installname
			  send_stats "瀹夎鎸囧畾杞欢"
			  ;;
		  42)
			  clear
			  read -e -p "璇疯緭鍏ュ嵏杞界殑宸ュ叿鍚嶏紙htop ufw tmux cmatrix锛? " removename
			  remove $removename
			  send_stats "鍗歌浇鎸囧畾杞欢"
			  ;;

		  0)
			  kejilion
			  ;;

		  *)
			  echo "鏃犳晥鐨勮緭鍏?"
			  ;;
	  esac
	  break_end
  done




}


linux_bbr() {
	clear
	send_stats "bbr绠＄悊"
	if [ -f "/etc/alpine-release" ]; then
		while true; do
			  clear
			  local congestion_algorithm=$(sysctl -n net.ipv4.tcp_congestion_control)
			  local queue_algorithm=$(sysctl -n net.core.default_qdisc)
			  echo "褰撳墠TCP闃诲绠楁硶: $congestion_algorithm $queue_algorithm"

			  echo ""
			  echo "BBR绠＄悊"
			  echo "------------------------"
			  echo "1. 寮€鍚疊BRv3              2. 鍏抽棴BBRv3锛堜細閲嶅惎锛?
			  echo "------------------------"
			  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
			  echo "------------------------"
			  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice

			  case $sub_choice in
				  1)
					bbr_on
					send_stats "alpine寮€鍚痓br3"
					  ;;
				  2)
					sed -i '/net.ipv4.tcp_congestion_control=/d' /etc/sysctl.conf
					sysctl -p
					server_reboot
					  ;;
				  *)
					  break  # 璺冲嚭寰幆锛岄€€鍑鸿彍鍗?
					  ;;

			  esac
		done
	else
		install wget
		wget --no-check-certificate -O tcpx.sh ${gh_proxy}raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcpx.sh
		chmod +x tcpx.sh
		./tcpx.sh
	fi


}





docker_ssh_migration() {

	is_compose_container() {
		local container=$1
		docker inspect "$container" | jq -e '.[0].Config.Labels["com.docker.compose.project"]' >/dev/null 2>&1
	}

	list_backups() {
		local BACKUP_ROOT="/tmp"
		echo -e "${gl_kjlan}褰撳墠澶囦唤鍒楄〃:${gl_bai}"
		ls -1dt ${BACKUP_ROOT}/docker_backup_* 2>/dev/null || echo "鏃犲浠?
	}



	# ----------------------------
	# 澶囦唤
	# ----------------------------
	backup_docker() {
		send_stats "Docker澶囦唤"

		echo -e "${gl_kjlan}姝ｅ湪澶囦唤 Docker 瀹瑰櫒...${gl_bai}"
		docker ps --format '{{.Names}}'
		read -e -p  "璇疯緭鍏ヨ澶囦唤鐨勫鍣ㄥ悕锛堝涓┖鏍煎垎闅旓紝鍥炶溅澶囦唤鍏ㄩ儴杩愯涓鍣級: " containers

		install tar jq gzip
		install_docker

		local BACKUP_ROOT="/tmp"
		local DATE_STR=$(date +%Y%m%d_%H%M%S)
		local TARGET_CONTAINERS=()
		if [ -z "$containers" ]; then
			mapfile -t TARGET_CONTAINERS < <(docker ps --format '{{.Names}}')
		else
			read -ra TARGET_CONTAINERS <<< "$containers"
		fi
		[[ ${#TARGET_CONTAINERS[@]} -eq 0 ]] && { echo -e "${gl_hong}娌℃湁鎵惧埌瀹瑰櫒${gl_bai}"; return; }

		local BACKUP_DIR="${BACKUP_ROOT}/docker_backup_${DATE_STR}"
		mkdir -p "$BACKUP_DIR"

		local RESTORE_SCRIPT="${BACKUP_DIR}/docker_restore.sh"
		echo "#!/bin/bash" > "$RESTORE_SCRIPT"
		echo "set -e" >> "$RESTORE_SCRIPT"
		echo "# 鑷姩鐢熸垚鐨勮繕鍘熻剼鏈? >> "$RESTORE_SCRIPT"

		# 璁板綍宸叉墦鍖呰繃鐨?Compose 椤圭洰璺緞锛岄伩鍏嶉噸澶嶆墦鍖?
		declare -A PACKED_COMPOSE_PATHS=()

		for c in "${TARGET_CONTAINERS[@]}"; do
			echo -e "${gl_lv}澶囦唤瀹瑰櫒: $c${gl_bai}"
			local inspect_file="${BACKUP_DIR}/${c}_inspect.json"
			docker inspect "$c" > "$inspect_file"

			if is_compose_container "$c"; then
				echo -e "${gl_kjlan}妫€娴嬪埌 $c 鏄?docker-compose 瀹瑰櫒${gl_bai}"
				local project_dir=$(docker inspect "$c" | jq -r '.[0].Config.Labels["com.docker.compose.project.working_dir"] // empty')
				local project_name=$(docker inspect "$c" | jq -r '.[0].Config.Labels["com.docker.compose.project"] // empty')

				if [ -z "$project_dir" ]; then
					read -e -p  "鏈娴嬪埌 compose 鐩綍锛岃鎵嬪姩杈撳叆璺緞: " project_dir
				fi

				# 濡傛灉璇?Compose 椤圭洰宸茬粡鎵撳寘杩囷紝璺宠繃
				if [[ -n "${PACKED_COMPOSE_PATHS[$project_dir]}" ]]; then
					echo -e "${gl_huang}Compose 椤圭洰 [$project_name] 宸插浠借繃锛岃烦杩囬噸澶嶆墦鍖?..${gl_bai}"
					continue
				fi

				if [ -f "$project_dir/docker-compose.yml" ]; then
					echo "compose" > "${BACKUP_DIR}/backup_type_${project_name}"
					echo "$project_dir" > "${BACKUP_DIR}/compose_path_${project_name}.txt"
					tar -czf "${BACKUP_DIR}/compose_project_${project_name}.tar.gz" -C "$project_dir" .
					echo "# docker-compose 鎭㈠: $project_name" >> "$RESTORE_SCRIPT"
					echo "cd \"$project_dir\" && docker compose up -d" >> "$RESTORE_SCRIPT"
					PACKED_COMPOSE_PATHS["$project_dir"]=1
					echo -e "${gl_lv}Compose 椤圭洰 [$project_name] 宸叉墦鍖? ${project_dir}${gl_bai}"
				else
					echo -e "${gl_hong}鏈壘鍒?docker-compose.yml锛岃烦杩囨瀹瑰櫒...${gl_bai}"
				fi
			else
				# 鏅€氬鍣ㄥ浠藉嵎
				local VOL_PATHS
				VOL_PATHS=$(docker inspect "$c" --format '{{range .Mounts}}{{.Source}} {{end}}')
				for path in $VOL_PATHS; do
					echo "鎵撳寘鍗? $path"
					tar -czpf "${BACKUP_DIR}/${c}_$(basename $path).tar.gz" -C / "$(echo $path | sed 's/^\///')"
				done

				# 绔彛
				local PORT_ARGS=""
				mapfile -t PORTS < <(jq -r '.[0].HostConfig.PortBindings | to_entries[] | "\(.value[0].HostPort):\(.key | split("/")[0])"' "$inspect_file" 2>/dev/null)
				for p in "${PORTS[@]}"; do PORT_ARGS+="-p $p "; done

				# 鐜鍙橀噺
				local ENV_VARS=""
				mapfile -t ENVS < <(jq -r '.[0].Config.Env[] | @sh' "$inspect_file")
				for e in "${ENVS[@]}"; do ENV_VARS+="-e $e "; done

				# 鍗锋槧灏?
				local VOL_ARGS=""
				for path in $VOL_PATHS; do VOL_ARGS+="-v $path:$path "; done

				# 闀滃儚
				local IMAGE
				IMAGE=$(jq -r '.[0].Config.Image' "$inspect_file")

				echo -e "\n# 杩樺師瀹瑰櫒: $c" >> "$RESTORE_SCRIPT"
				echo "docker run -d --name $c $PORT_ARGS $VOL_ARGS $ENV_VARS $IMAGE" >> "$RESTORE_SCRIPT"
			fi
		done


		# 澶囦唤 /home/docker 涓嬬殑鎵€鏈夋枃浠讹紙涓嶅惈瀛愮洰褰曪級
		if [ -d "/home/docker" ]; then
			echo -e "${gl_kjlan}澶囦唤 /home/docker 涓嬬殑鏂囦欢...${gl_bai}"
			find /home/docker -maxdepth 1 -type f | tar -czf "${BACKUP_DIR}/home_docker_files.tar.gz" -T -
			echo -e "${gl_lv}/home/docker 涓嬬殑鏂囦欢宸叉墦鍖呭埌: ${BACKUP_DIR}/home_docker_files.tar.gz${gl_bai}"
		fi

		chmod +x "$RESTORE_SCRIPT"
		echo -e "${gl_lv}澶囦唤瀹屾垚: ${BACKUP_DIR}${gl_bai}"
		echo -e "${gl_lv}鍙敤杩樺師鑴氭湰: ${RESTORE_SCRIPT}${gl_bai}"


	}

	# ----------------------------
	# 杩樺師
	# ----------------------------
	restore_docker() {

		send_stats "Docker杩樺師"
		read -e -p  "璇疯緭鍏ヨ杩樺師鐨勫浠界洰褰? " BACKUP_DIR
		[[ ! -d "$BACKUP_DIR" ]] && { echo -e "${gl_hong}澶囦唤鐩綍涓嶅瓨鍦?{gl_bai}"; return; }

		echo -e "${gl_kjlan}寮€濮嬫墽琛岃繕鍘熸搷浣?..${gl_bai}"

		install tar jq gzip
		install_docker

		# --------- 浼樺厛杩樺師 Compose 椤圭洰 ---------
		for f in "$BACKUP_DIR"/backup_type_*; do
			[[ ! -f "$f" ]] && continue
			if grep -q "compose" "$f"; then
				project_name=$(basename "$f" | sed 's/backup_type_//')
				path_file="$BACKUP_DIR/compose_path_${project_name}.txt"
				[[ -f "$path_file" ]] && original_path=$(cat "$path_file") || original_path=""
				[[ -z "$original_path" ]] && read -e -p  "鏈壘鍒板師濮嬭矾寰勶紝璇疯緭鍏ヨ繕鍘熺洰褰曡矾寰? " original_path

				# 妫€鏌ヨ compose 椤圭洰鐨勫鍣ㄦ槸鍚﹀凡缁忓湪杩愯
				running_count=$(docker ps --filter "label=com.docker.compose.project=$project_name" --format '{{.Names}}' | wc -l)
				if [[ "$running_count" -gt 0 ]]; then
					echo -e "${gl_huang}Compose 椤圭洰 [$project_name] 宸叉湁瀹瑰櫒鍦ㄨ繍琛岋紝璺宠繃杩樺師...${gl_bai}"
					continue
				fi

				read -e -p  "纭杩樺師 Compose 椤圭洰 [$project_name] 鍒拌矾寰?[$original_path] ? (y/n): " confirm
				[[ "$confirm" != "y" ]] && read -e -p  "璇疯緭鍏ユ柊鐨勮繕鍘熻矾寰? " original_path

				mkdir -p "$original_path"
				tar -xzf "$BACKUP_DIR/compose_project_${project_name}.tar.gz" -C "$original_path"
				echo -e "${gl_lv}Compose 椤圭洰 [$project_name] 宸茶В鍘嬪埌: $original_path${gl_bai}"

				cd "$original_path" || return
				docker compose down || true
				docker compose up -d
				echo -e "${gl_lv}Compose 椤圭洰 [$project_name] 杩樺師瀹屾垚锛?{gl_bai}"
			fi
		done

		# --------- 缁х画杩樺師鏅€氬鍣?---------
		echo -e "${gl_kjlan}妫€鏌ュ苟杩樺師鏅€?Docker 瀹瑰櫒...${gl_bai}"
		local has_container=false
		for json in "$BACKUP_DIR"/*_inspect.json; do
			[[ ! -f "$json" ]] && continue
			has_container=true
			container=$(basename "$json" | sed 's/_inspect.json//')
			echo -e "${gl_lv}澶勭悊瀹瑰櫒: $container${gl_bai}"

			# 妫€鏌ュ鍣ㄦ槸鍚﹀凡缁忓瓨鍦ㄤ笖姝ｅ湪杩愯
			if docker ps --format '{{.Names}}' | grep -q "^${container}$"; then
				echo -e "${gl_huang}瀹瑰櫒 [$container] 宸插湪杩愯锛岃烦杩囪繕鍘?..${gl_bai}"
				continue
			fi

			IMAGE=$(jq -r '.[0].Config.Image' "$json")
			[[ -z "$IMAGE" || "$IMAGE" == "null" ]] && { echo -e "${gl_hong}鏈壘鍒伴暅鍍忎俊鎭紝璺宠繃: $container${gl_bai}"; continue; }

			# 绔彛鏄犲皠
			PORT_ARGS=""
			mapfile -t PORTS < <(jq -r '.[0].HostConfig.PortBindings | to_entries[]? | "\(.value[0].HostPort):\(.key | split("/")[0])"' "$json")
			for p in "${PORTS[@]}"; do
				[[ -n "$p" ]] && PORT_ARGS="$PORT_ARGS -p $p"
			done

			# 鐜鍙橀噺
			ENV_ARGS=""
			mapfile -t ENVS < <(jq -r '.[0].Config.Env[]' "$json")
			for e in "${ENVS[@]}"; do
				ENV_ARGS="$ENV_ARGS -e \"$e\""
			done

			# 鍗锋槧灏?+ 鍗锋暟鎹仮澶?
			VOL_ARGS=""
			mapfile -t VOLS < <(jq -r '.[0].Mounts[] | "\(.Source):\(.Destination)"' "$json")
			for v in "${VOLS[@]}"; do
				VOL_SRC=$(echo "$v" | cut -d':' -f1)
				VOL_DST=$(echo "$v" | cut -d':' -f2)
				mkdir -p "$VOL_SRC"
				VOL_ARGS="$VOL_ARGS -v $VOL_SRC:$VOL_DST"

				VOL_FILE="$BACKUP_DIR/${container}_$(basename $VOL_SRC).tar.gz"
				if [[ -f "$VOL_FILE" ]]; then
					echo "鎭㈠鍗锋暟鎹? $VOL_SRC"
					tar -xzf "$VOL_FILE" -C /
				fi
			done

			# 鍒犻櫎宸插瓨鍦ㄤ絾鏈繍琛岀殑瀹瑰櫒
			if docker ps -a --format '{{.Names}}' | grep -q "^${container}$"; then
				echo -e "${gl_huang}瀹瑰櫒 [$container] 瀛樺湪浣嗘湭杩愯锛屽垹闄ゆ棫瀹瑰櫒...${gl_bai}"
				docker rm -f "$container"
			fi

			# 鍚姩瀹瑰櫒
			echo "鎵ц杩樺師鍛戒护: docker run -d --name \"$container\" $PORT_ARGS $VOL_ARGS $ENV_ARGS \"$IMAGE\""
			eval "docker run -d --name \"$container\" $PORT_ARGS $VOL_ARGS $ENV_ARGS \"$IMAGE\""
		done

		[[ "$has_container" == false ]] && echo -e "${gl_huang}鏈壘鍒版櫘閫氬鍣ㄧ殑澶囦唤淇℃伅${gl_bai}"

		# 杩樺師 /home/docker 涓嬬殑鏂囦欢
		if [ -f "$BACKUP_DIR/home_docker_files.tar.gz" ]; then
			echo -e "${gl_kjlan}姝ｅ湪杩樺師 /home/docker 涓嬬殑鏂囦欢...${gl_bai}"
			mkdir -p /home/docker
			tar -xzf "$BACKUP_DIR/home_docker_files.tar.gz" -C /
			echo -e "${gl_lv}/home/docker 涓嬬殑鏂囦欢宸茶繕鍘熷畬鎴?{gl_bai}"
		else
			echo -e "${gl_huang}鏈壘鍒?/home/docker 涓嬫枃浠剁殑澶囦唤锛岃烦杩?..${gl_bai}"
		fi


	}


	# ----------------------------
	# 杩佺Щ
	# ----------------------------
	migrate_docker() {
		send_stats "Docker杩佺Щ"
		install jq
		read -e -p  "璇疯緭鍏ヨ杩佺Щ鐨勫浠界洰褰? " BACKUP_DIR
		[[ ! -d "$BACKUP_DIR" ]] && { echo -e "${gl_hong}澶囦唤鐩綍涓嶅瓨鍦?{gl_bai}"; return; }

		read -e -p  "鐩爣鏈嶅姟鍣↖P: " TARGET_IP
		read -e -p  "鐩爣鏈嶅姟鍣⊿SH鐢ㄦ埛鍚? " TARGET_USER
		read -e -p "鐩爣鏈嶅姟鍣⊿SH绔彛 [榛樿22]: " TARGET_PORT
		local TARGET_PORT=${TARGET_PORT:-22}

		local LATEST_TAR="$BACKUP_DIR"

		echo -e "${gl_huang}浼犺緭澶囦唤涓?..${gl_bai}"
		if [[ -z "$TARGET_PASS" ]]; then
			# 浣跨敤瀵嗛挜鐧诲綍
			scp -P "$TARGET_PORT" -o StrictHostKeyChecking=no -r "$LATEST_TAR" "$TARGET_USER@$TARGET_IP:/tmp/"
		fi

	}

	# ----------------------------
	# 鍒犻櫎澶囦唤
	# ----------------------------
	delete_backup() {
		send_stats "Docker澶囦唤鏂囦欢鍒犻櫎"
		read -e -p  "璇疯緭鍏ヨ鍒犻櫎鐨勫浠界洰褰? " BACKUP_DIR
		[[ ! -d "$BACKUP_DIR" ]] && { echo -e "${gl_hong}澶囦唤鐩綍涓嶅瓨鍦?{gl_bai}"; return; }
		rm -rf "$BACKUP_DIR"
		echo -e "${gl_lv}宸插垹闄ゅ浠? ${BACKUP_DIR}${gl_bai}"
	}

	# ----------------------------
	# 涓昏彍鍗?
	# ----------------------------
	main_menu() {
		send_stats "Docker澶囦唤杩佺Щ杩樺師"
		while true; do
			clear
			echo "------------------------"
			echo -e "Docker澶囦唤/杩佺Щ/杩樺師宸ュ叿"
			echo "------------------------"
			list_backups
			echo -e ""
			echo "------------------------"
			echo -e "1. 澶囦唤docker椤圭洰"
			echo -e "2. 杩佺Щdocker椤圭洰"
			echo -e "3. 杩樺師docker椤圭洰"
			echo -e "4. 鍒犻櫎docker椤圭洰鐨勫浠芥枃浠?
			echo "------------------------"
			echo -e "0. 杩斿洖涓婁竴绾ч€夊崟"
			echo "------------------------"
			read -e -p  "璇烽€夋嫨: " choice
			case $choice in
				1) backup_docker ;;
				2) migrate_docker ;;
				3) restore_docker ;;
				4) delete_backup ;;
				0) return ;;
				*) echo -e "${gl_hong}鏃犳晥閫夐」${gl_bai}" ;;
			esac
		break_end
		done
	}

	main_menu
}





linux_docker() {

	while true; do
	  clear
	  # send_stats "docker绠＄悊"
	  echo -e "Docker绠＄悊"
	  docker_tato
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}1.   ${gl_bai}瀹夎鏇存柊Docker鐜 ${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}2.   ${gl_bai}鏌ョ湅Docker鍏ㄥ眬鐘舵€?${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}3.   ${gl_bai}Docker瀹瑰櫒绠＄悊 ${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}4.   ${gl_bai}Docker闀滃儚绠＄悊"
	  echo -e "${gl_kjlan}5.   ${gl_bai}Docker缃戠粶绠＄悊"
	  echo -e "${gl_kjlan}6.   ${gl_bai}Docker鍗风鐞?
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}7.   ${gl_bai}娓呯悊鏃犵敤鐨刣ocker瀹瑰櫒鍜岄暅鍍忕綉缁滄暟鎹嵎"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}8.   ${gl_bai}鏇存崲Docker婧?
	  echo -e "${gl_kjlan}9.   ${gl_bai}缂栬緫daemon.json鏂囦欢"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}11.  ${gl_bai}寮€鍚疍ocker-ipv6璁块棶"
	  echo -e "${gl_kjlan}12.  ${gl_bai}鍏抽棴Docker-ipv6璁块棶"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}19.  ${gl_bai}澶囦唤/杩佺Щ/杩樺師Docker鐜"
	  echo -e "${gl_kjlan}20.  ${gl_bai}鍗歌浇Docker鐜"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}0.   ${gl_bai}杩斿洖涓昏彍鍗?
	  echo -e "${gl_kjlan}------------------------${gl_bai}"
	  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice

	  case $sub_choice in
		  1)
			clear
			send_stats "瀹夎docker鐜"
			install_add_docker

			  ;;
		  2)
			  clear
			  local container_count=$(docker ps -a -q 2>/dev/null | wc -l)
			  local image_count=$(docker images -q 2>/dev/null | wc -l)
			  local network_count=$(docker network ls -q 2>/dev/null | wc -l)
			  local volume_count=$(docker volume ls -q 2>/dev/null | wc -l)

			  send_stats "docker鍏ㄥ眬鐘舵€?
			  echo "Docker鐗堟湰"
			  docker -v
			  docker compose version

			  echo ""
			  echo -e "Docker闀滃儚: ${gl_lv}$image_count${gl_bai} "
			  docker image ls
			  echo ""
			  echo -e "Docker瀹瑰櫒: ${gl_lv}$container_count${gl_bai}"
			  docker ps -a
			  echo ""
			  echo -e "Docker鍗? ${gl_lv}$volume_count${gl_bai}"
			  docker volume ls
			  echo ""
			  echo -e "Docker缃戠粶: ${gl_lv}$network_count${gl_bai}"
			  docker network ls
			  echo ""

			  ;;
		  3)
			  docker_ps
			  ;;
		  4)
			  docker_image
			  ;;

		  5)
			  while true; do
				  clear
				  send_stats "Docker缃戠粶绠＄悊"
				  echo "Docker缃戠粶鍒楄〃"
				  echo "------------------------------------------------------------"
				  docker network ls
				  echo ""

				  echo "------------------------------------------------------------"
				  container_ids=$(docker ps -q)
				  printf "%-25s %-25s %-25s\n" "瀹瑰櫒鍚嶇О" "缃戠粶鍚嶇О" "IP鍦板潃"

				  for container_id in $container_ids; do
					  local container_info=$(docker inspect --format '{{ .Name }}{{ range $network, $config := .NetworkSettings.Networks }} {{ $network }} {{ $config.IPAddress }}{{ end }}' "$container_id")

					  local container_name=$(echo "$container_info" | awk '{print $1}')
					  local network_info=$(echo "$container_info" | cut -d' ' -f2-)

					  while IFS= read -r line; do
						  local network_name=$(echo "$line" | awk '{print $1}')
						  local ip_address=$(echo "$line" | awk '{print $2}')

						  printf "%-20s %-20s %-15s\n" "$container_name" "$network_name" "$ip_address"
					  done <<< "$network_info"
				  done

				  echo ""
				  echo "缃戠粶鎿嶄綔"
				  echo "------------------------"
				  echo "1. 鍒涘缓缃戠粶"
				  echo "2. 鍔犲叆缃戠粶"
				  echo "3. 閫€鍑虹綉缁?
				  echo "4. 鍒犻櫎缃戠粶"
				  echo "------------------------"
				  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
				  echo "------------------------"
				  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice

				  case $sub_choice in
					  1)
						  send_stats "鍒涘缓缃戠粶"
						  read -e -p "璁剧疆鏂扮綉缁滃悕: " dockernetwork
						  docker network create $dockernetwork
						  ;;
					  2)
						  send_stats "鍔犲叆缃戠粶"
						  read -e -p "鍔犲叆缃戠粶鍚? " dockernetwork
						  read -e -p "閭ｄ簺瀹瑰櫒鍔犲叆璇ョ綉缁滐紙澶氫釜瀹瑰櫒鍚嶈鐢ㄧ┖鏍煎垎闅旓級: " dockernames

						  for dockername in $dockernames; do
							  docker network connect $dockernetwork $dockername
						  done
						  ;;
					  3)
						  send_stats "鍔犲叆缃戠粶"
						  read -e -p "閫€鍑虹綉缁滃悕: " dockernetwork
						  read -e -p "閭ｄ簺瀹瑰櫒閫€鍑鸿缃戠粶锛堝涓鍣ㄥ悕璇风敤绌烘牸鍒嗛殧锛? " dockernames

						  for dockername in $dockernames; do
							  docker network disconnect $dockernetwork $dockername
						  done

						  ;;

					  4)
						  send_stats "鍒犻櫎缃戠粶"
						  read -e -p "璇疯緭鍏ヨ鍒犻櫎鐨勭綉缁滃悕: " dockernetwork
						  docker network rm $dockernetwork
						  ;;

					  *)
						  break  # 璺冲嚭寰幆锛岄€€鍑鸿彍鍗?
						  ;;
				  esac
			  done
			  ;;

		  6)
			  while true; do
				  clear
				  send_stats "Docker鍗风鐞?
				  echo "Docker鍗峰垪琛?
				  docker volume ls
				  echo ""
				  echo "鍗锋搷浣?
				  echo "------------------------"
				  echo "1. 鍒涘缓鏂板嵎"
				  echo "2. 鍒犻櫎鎸囧畾鍗?
				  echo "3. 鍒犻櫎鎵€鏈夊嵎"
				  echo "------------------------"
				  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
				  echo "------------------------"
				  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice

				  case $sub_choice in
					  1)
						  send_stats "鏂板缓鍗?
						  read -e -p "璁剧疆鏂板嵎鍚? " dockerjuan
						  docker volume create $dockerjuan

						  ;;
					  2)
						  read -e -p "杈撳叆鍒犻櫎鍗峰悕锛堝涓嵎鍚嶈鐢ㄧ┖鏍煎垎闅旓級: " dockerjuans

						  for dockerjuan in $dockerjuans; do
							  docker volume rm $dockerjuan
						  done

						  ;;

					   3)
						  send_stats "鍒犻櫎鎵€鏈夊嵎"
						  read -e -p "$(echo -e "${gl_hong}娉ㄦ剰: ${gl_bai}纭畾鍒犻櫎鎵€鏈夋湭浣跨敤鐨勫嵎鍚楋紵(Y/N): ")" choice
						  case "$choice" in
							[Yy])
							  docker volume prune -f
							  ;;
							[Nn])
							  ;;
							*)
							  echo "鏃犳晥鐨勯€夋嫨锛岃杈撳叆 Y 鎴?N銆?
							  ;;
						  esac
						  ;;

					  *)
						  break  # 璺冲嚭寰幆锛岄€€鍑鸿彍鍗?
						  ;;
				  esac
			  done
			  ;;
		  7)
			  clear
			  send_stats "Docker娓呯悊"
			  read -e -p "$(echo -e "${gl_huang}鎻愮ず: ${gl_bai}灏嗘竻鐞嗘棤鐢ㄧ殑闀滃儚瀹瑰櫒缃戠粶锛屽寘鎷仠姝㈢殑瀹瑰櫒锛岀‘瀹氭竻鐞嗗悧锛?Y/N): ")" choice
			  case "$choice" in
				[Yy])
				  docker system prune -af --volumes
				  ;;
				[Nn])
				  ;;
				*)
				  echo "鏃犳晥鐨勯€夋嫨锛岃杈撳叆 Y 鎴?N銆?
				  ;;
			  esac
			  ;;
		  8)
			  clear
			  send_stats "Docker婧?
			  bash <(curl -sSL https://linuxmirrors.cn/docker.sh)
			  ;;

		  9)
			  clear
			  install nano
			  mkdir -p /etc/docker && nano /etc/docker/daemon.json
			  restart docker
			  ;;




		  11)
			  clear
			  send_stats "Docker v6 寮€"
			  docker_ipv6_on
			  ;;

		  12)
			  clear
			  send_stats "Docker v6 鍏?
			  docker_ipv6_off
			  ;;

		  19)
			  docker_ssh_migration
			  ;;


		  20)
			  clear
			  send_stats "Docker鍗歌浇"
			  read -e -p "$(echo -e "${gl_hong}娉ㄦ剰: ${gl_bai}纭畾鍗歌浇docker鐜鍚楋紵(Y/N): ")" choice
			  case "$choice" in
				[Yy])
				  docker ps -a -q | xargs -r docker rm -f && docker images -q | xargs -r docker rmi && docker network prune -f && docker volume prune -f
				  remove docker docker-compose docker-ce docker-ce-cli containerd.io
				  rm -f /etc/docker/daemon.json
				  hash -r
				  ;;
				[Nn])
				  ;;
				*)
				  echo "鏃犳晥鐨勯€夋嫨锛岃杈撳叆 Y 鎴?N銆?
				  ;;
			  esac
			  ;;

		  0)
			  kejilion
			  ;;
		  *)
			  echo "鏃犳晥鐨勮緭鍏?"
			  ;;
	  esac
	  break_end


	done


}



linux_test() {

	while true; do
	  clear
	  # send_stats "娴嬭瘯鑴氭湰鍚堥泦"
	  echo -e "娴嬭瘯鑴氭湰鍚堥泦"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}IP鍙婅В閿佺姸鎬佹娴?
	  echo -e "${gl_kjlan}1.   ${gl_bai}ChatGPT 瑙ｉ攣鐘舵€佹娴?
	  echo -e "${gl_kjlan}2.   ${gl_bai}Region 娴佸獟浣撹В閿佹祴璇?
	  echo -e "${gl_kjlan}3.   ${gl_bai}yeahwu 娴佸獟浣撹В閿佹娴?
	  echo -e "${gl_kjlan}4.   ${gl_bai}xykt IP璐ㄩ噺浣撴鑴氭湰 ${gl_huang}鈽?{gl_bai}"

	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}缃戠粶绾胯矾娴嬮€?
	  echo -e "${gl_kjlan}11.  ${gl_bai}besttrace 涓夌綉鍥炵▼寤惰繜璺敱娴嬭瘯"
	  echo -e "${gl_kjlan}12.  ${gl_bai}mtr_trace 涓夌綉鍥炵▼绾胯矾娴嬭瘯"
	  echo -e "${gl_kjlan}13.  ${gl_bai}Superspeed 涓夌綉娴嬮€?
	  echo -e "${gl_kjlan}14.  ${gl_bai}nxtrace 蹇€熷洖绋嬫祴璇曡剼鏈?
	  echo -e "${gl_kjlan}15.  ${gl_bai}nxtrace 鎸囧畾IP鍥炵▼娴嬭瘯鑴氭湰"
	  echo -e "${gl_kjlan}16.  ${gl_bai}ludashi2020 涓夌綉绾胯矾娴嬭瘯"
	  echo -e "${gl_kjlan}17.  ${gl_bai}i-abc 澶氬姛鑳芥祴閫熻剼鏈?
	  echo -e "${gl_kjlan}18.  ${gl_bai}NetQuality 缃戠粶璐ㄩ噺浣撴鑴氭湰 ${gl_huang}鈽?{gl_bai}"

	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}纭欢鎬ц兘娴嬭瘯"
	  echo -e "${gl_kjlan}21.  ${gl_bai}yabs 鎬ц兘娴嬭瘯"
	  echo -e "${gl_kjlan}22.  ${gl_bai}icu/gb5 CPU鎬ц兘娴嬭瘯鑴氭湰"

	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}缁煎悎鎬ф祴璇?
	  echo -e "${gl_kjlan}31.  ${gl_bai}bench 鎬ц兘娴嬭瘯"
	  echo -e "${gl_kjlan}32.  ${gl_bai}spiritysdx 铻嶅悎鎬祴璇?${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}33.  ${gl_bai}nodequality 铻嶅悎鎬祴璇?${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}0.   ${gl_bai}杩斿洖涓昏彍鍗?
	  echo -e "${gl_kjlan}------------------------${gl_bai}"
	  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice

	  case $sub_choice in
		  1)
			  clear
			  send_stats "ChatGPT瑙ｉ攣鐘舵€佹娴?
			  bash <(curl -Ls https://cdn.jsdelivr.net/gh/missuo/OpenAI-Checker/openai.sh)
			  ;;
		  2)
			  clear
			  send_stats "Region娴佸獟浣撹В閿佹祴璇?
			  bash <(curl -L -s check.unlock.media)
			  ;;
		  3)
			  clear
			  send_stats "yeahwu娴佸獟浣撹В閿佹娴?
			  install wget
			  wget -qO- ${gh_proxy}github.com/yeahwu/check/raw/main/check.sh | bash
			  ;;
		  4)
			  clear
			  send_stats "xykt_IP璐ㄩ噺浣撴鑴氭湰"
			  bash <(curl -Ls IP.Check.Place)
			  ;;


		  11)
			  clear
			  send_stats "besttrace涓夌綉鍥炵▼寤惰繜璺敱娴嬭瘯"
			  install wget
			  wget -qO- git.io/besttrace | bash
			  ;;
		  12)
			  clear
			  send_stats "mtr_trace涓夌綉鍥炵▼绾胯矾娴嬭瘯"
			  curl ${gh_proxy}raw.githubusercontent.com/zhucaidan/mtr_trace/main/mtr_trace.sh | bash
			  ;;
		  13)
			  clear
			  send_stats "Superspeed涓夌綉娴嬮€?
			  bash <(curl -Lso- https://git.io/superspeed_uxh)
			  ;;
		  14)
			  clear
			  send_stats "nxtrace蹇€熷洖绋嬫祴璇曡剼鏈?
			  curl nxtrace.org/nt |bash
			  nexttrace --fast-trace --tcp
			  ;;
		  15)
			  clear
			  send_stats "nxtrace鎸囧畾IP鍥炵▼娴嬭瘯鑴氭湰"
			  echo "鍙弬鑰冪殑IP鍒楄〃"
			  echo "------------------------"
			  echo "鍖椾含鐢典俊: 219.141.136.12"
			  echo "鍖椾含鑱旈€? 202.106.50.1"
			  echo "鍖椾含绉诲姩: 221.179.155.161"
			  echo "涓婃捣鐢典俊: 202.96.209.133"
			  echo "涓婃捣鑱旈€? 210.22.97.1"
			  echo "涓婃捣绉诲姩: 211.136.112.200"
			  echo "骞垮窞鐢典俊: 58.60.188.222"
			  echo "骞垮窞鑱旈€? 210.21.196.6"
			  echo "骞垮窞绉诲姩: 120.196.165.24"
			  echo "鎴愰兘鐢典俊: 61.139.2.69"
			  echo "鎴愰兘鑱旈€? 119.6.6.6"
			  echo "鎴愰兘绉诲姩: 211.137.96.205"
			  echo "婀栧崡鐢典俊: 36.111.200.100"
			  echo "婀栧崡鑱旈€? 42.48.16.100"
			  echo "婀栧崡绉诲姩: 39.134.254.6"
			  echo "------------------------"

			  read -e -p "杈撳叆涓€涓寚瀹欼P: " testip
			  curl nxtrace.org/nt |bash
			  nexttrace $testip
			  ;;

		  16)
			  clear
			  send_stats "ludashi2020涓夌綉绾胯矾娴嬭瘯"
			  curl ${gh_proxy}raw.githubusercontent.com/ludashi2020/backtrace/main/install.sh -sSf | sh
			  ;;

		  17)
			  clear
			  send_stats "i-abc澶氬姛鑳芥祴閫熻剼鏈?
			  bash <(curl -sL ${gh_proxy}raw.githubusercontent.com/i-abc/Speedtest/main/speedtest.sh)
			  ;;

		  18)
			  clear
			  send_stats "缃戠粶璐ㄩ噺娴嬭瘯鑴氭湰"
			  bash <(curl -sL Net.Check.Place)
			  ;;

		  21)
			  clear
			  send_stats "yabs鎬ц兘娴嬭瘯"
			  check_swap
			  curl -sL yabs.sh | bash -s -- -i -5
			  ;;
		  22)
			  clear
			  send_stats "icu/gb5 CPU鎬ц兘娴嬭瘯鑴氭湰"
			  check_swap
			  bash <(curl -sL bash.icu/gb5)
			  ;;

		  31)
			  clear
			  send_stats "bench鎬ц兘娴嬭瘯"
			  curl -Lso- bench.sh | bash
			  ;;
		  32)
			  send_stats "spiritysdx铻嶅悎鎬祴璇?
			  clear
			  curl -L ${gh_proxy}gitlab.com/spiritysdx/za/-/raw/main/ecs.sh -o ecs.sh && chmod +x ecs.sh && bash ecs.sh
			  ;;

		  33)
			  send_stats "nodequality铻嶅悎鎬祴璇?
			  clear
			  bash <(curl -sL https://run.NodeQuality.com)
			  ;;



		  0)
			  kejilion

			  ;;
		  *)
			  echo "鏃犳晥鐨勮緭鍏?"
			  ;;
	  esac
	  break_end

	done


}


linux_Oracle() {


	 while true; do
	  clear
	  send_stats "鐢查鏂囦簯鑴氭湰鍚堥泦"
	  echo -e "鐢查鏂囦簯鑴氭湰鍚堥泦"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}1.   ${gl_bai}瀹夎闂茬疆鏈哄櫒娲昏穬鑴氭湰"
	  echo -e "${gl_kjlan}2.   ${gl_bai}鍗歌浇闂茬疆鏈哄櫒娲昏穬鑴氭湰"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}3.   ${gl_bai}DD閲嶈绯荤粺鑴氭湰"
	  echo -e "${gl_kjlan}4.   ${gl_bai}R鎺㈤暱寮€鏈鸿剼鏈?
	  echo -e "${gl_kjlan}5.   ${gl_bai}寮€鍚疪OOT瀵嗙爜鐧诲綍妯″紡"
	  echo -e "${gl_kjlan}6.   ${gl_bai}IPV6鎭㈠宸ュ叿"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}0.   ${gl_bai}杩斿洖涓昏彍鍗?
	  echo -e "${gl_kjlan}------------------------${gl_bai}"
	  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice

	  case $sub_choice in
		  1)
			  clear
			  echo "娲昏穬鑴氭湰: CPU鍗犵敤10-20% 鍐呭瓨鍗犵敤20% "
			  read -e -p "纭畾瀹夎鍚楋紵(Y/N): " choice
			  case "$choice" in
				[Yy])

				  install_docker

				  # 璁剧疆榛樿鍊?
				  local DEFAULT_CPU_CORE=1
				  local DEFAULT_CPU_UTIL="10-20"
				  local DEFAULT_MEM_UTIL=20
				  local DEFAULT_SPEEDTEST_INTERVAL=120

				  # 鎻愮ず鐢ㄦ埛杈撳叆CPU鏍稿績鏁板拰鍗犵敤鐧惧垎姣旓紝濡傛灉鍥炶溅鍒欎娇鐢ㄩ粯璁ゅ€?
				  read -e -p "璇疯緭鍏PU鏍稿績鏁?[榛樿: $DEFAULT_CPU_CORE]: " cpu_core
				  local cpu_core=${cpu_core:-$DEFAULT_CPU_CORE}

				  read -e -p "璇疯緭鍏PU鍗犵敤鐧惧垎姣旇寖鍥达紙渚嬪10-20锛?[榛樿: $DEFAULT_CPU_UTIL]: " cpu_util
				  local cpu_util=${cpu_util:-$DEFAULT_CPU_UTIL}

				  read -e -p "璇疯緭鍏ュ唴瀛樺崰鐢ㄧ櫨鍒嗘瘮 [榛樿: $DEFAULT_MEM_UTIL]: " mem_util
				  local mem_util=${mem_util:-$DEFAULT_MEM_UTIL}

				  read -e -p "璇疯緭鍏peedtest闂撮殧鏃堕棿锛堢锛?[榛樿: $DEFAULT_SPEEDTEST_INTERVAL]: " speedtest_interval
				  local speedtest_interval=${speedtest_interval:-$DEFAULT_SPEEDTEST_INTERVAL}

				  # 杩愯Docker瀹瑰櫒
				  docker run -d --name=lookbusy --restart=always \
					  -e TZ=Asia/Shanghai \
					  -e CPU_UTIL="$cpu_util" \
					  -e CPU_CORE="$cpu_core" \
					  -e MEM_UTIL="$mem_util" \
					  -e SPEEDTEST_INTERVAL="$speedtest_interval" \
					  fogforest/lookbusy
				  send_stats "鐢查鏂囦簯瀹夎娲昏穬鑴氭湰"

				  ;;
				[Nn])

				  ;;
				*)
				  echo "鏃犳晥鐨勯€夋嫨锛岃杈撳叆 Y 鎴?N銆?
				  ;;
			  esac
			  ;;
		  2)
			  clear
			  docker rm -f lookbusy
			  docker rmi fogforest/lookbusy
			  send_stats "鐢查鏂囦簯鍗歌浇娲昏穬鑴氭湰"
			  ;;

		  3)
		  clear
		  echo "閲嶈绯荤粺"
		  echo "--------------------------------"
		  echo -e "${gl_hong}娉ㄦ剰: ${gl_bai}閲嶈鏈夐闄╁け鑱旓紝涓嶆斁蹇冭€呮厧鐢ㄣ€傞噸瑁呴璁¤姳璐?5鍒嗛挓锛岃鎻愬墠澶囦唤鏁版嵁銆?
		  read -e -p "纭畾缁х画鍚楋紵(Y/N): " choice

		  case "$choice" in
			[Yy])
			  while true; do
				read -e -p "璇烽€夋嫨瑕侀噸瑁呯殑绯荤粺:  1. Debian12 | 2. Ubuntu20.04 : " sys_choice

				case "$sys_choice" in
				  1)
					local xitong="-d 12"
					break  # 缁撴潫寰幆
					;;
				  2)
					local xitong="-u 20.04"
					break  # 缁撴潫寰幆
					;;
				  *)
					echo "鏃犳晥鐨勯€夋嫨锛岃閲嶆柊杈撳叆銆?
					;;
				esac
			  done

			  read -e -p "璇疯緭鍏ヤ綘閲嶈鍚庣殑瀵嗙爜: " vpspasswd
			  install wget
			  bash <(wget --no-check-certificate -qO- "${gh_proxy}raw.githubusercontent.com/MoeClub/Note/master/InstallNET.sh") $xitong -v 64 -p $vpspasswd -port 22
			  send_stats "鐢查鏂囦簯閲嶈绯荤粺鑴氭湰"
			  ;;
			[Nn])
			  echo "宸插彇娑?
			  ;;
			*)
			  echo "鏃犳晥鐨勯€夋嫨锛岃杈撳叆 Y 鎴?N銆?
			  ;;
		  esac
			  ;;

		  4)
			  clear
			  send_stats "R鎺㈤暱寮€鏈鸿剼鏈?
			  bash <(wget -qO- ${gh_proxy}github.com/Yohann0617/oci-helper/releases/latest/download/sh_oci-helper_install.sh)
			  ;;
		  5)
			  clear
			  add_sshpasswd
			  ;;
		  6)
			  clear
			  bash <(curl -L -s jhb.ovh/jb/v6.sh)
			  echo "璇ュ姛鑳界敱jhb澶х鎻愪緵锛屾劅璋粬锛?
			  send_stats "ipv6淇"
			  ;;
		  0)
			  kejilion

			  ;;
		  *)
			  echo "鏃犳晥鐨勮緭鍏?"
			  ;;
	  esac
	  break_end

	done



}





docker_tato() {

	local container_count=$(docker ps -a -q 2>/dev/null | wc -l)
	local image_count=$(docker images -q 2>/dev/null | wc -l)
	local network_count=$(docker network ls -q 2>/dev/null | wc -l)
	local volume_count=$(docker volume ls -q 2>/dev/null | wc -l)

	if command -v docker &> /dev/null; then
		echo -e "${gl_kjlan}------------------------"
		echo -e "${gl_lv}鐜宸茬粡瀹夎${gl_bai}  瀹瑰櫒: ${gl_lv}$container_count${gl_bai}  闀滃儚: ${gl_lv}$image_count${gl_bai}  缃戠粶: ${gl_lv}$network_count${gl_bai}  鍗? ${gl_lv}$volume_count${gl_bai}"
	fi
}



ldnmp_tato() {
local cert_count=$(ls /home/web/certs/*_cert.pem 2>/dev/null | wc -l)
local output="${gl_lv}${cert_count}${gl_bai}"

local dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml 2>/dev/null | tr -d '[:space:]')
if [ -n "$dbrootpasswd" ]; then
	local db_count=$(docker exec mysql mysql -u root -p"$dbrootpasswd" -e "SHOW DATABASES;" 2>/dev/null | grep -Ev "Database|information_schema|mysql|performance_schema|sys" | wc -l)
fi

local db_output="${gl_lv}${db_count}${gl_bai}"


if command -v docker &>/dev/null; then
	if docker ps --filter "name=nginx" --filter "status=running" | grep -q nginx; then
		echo -e "${gl_huang}------------------------"
		echo -e "${gl_lv}鐜宸插畨瑁?{gl_bai}  绔欑偣: $output  鏁版嵁搴? $db_output"
	fi
fi

}


fix_phpfpm_conf() {
	local container_name=$1
	docker exec "$container_name" sh -c "mkdir -p /run/$container_name && chmod 777 /run/$container_name"
	docker exec "$container_name" sh -c "sed -i '1i [global]\\ndaemonize = no' /usr/local/etc/php-fpm.d/www.conf"
	docker exec "$container_name" sh -c "sed -i '/^listen =/d' /usr/local/etc/php-fpm.d/www.conf"
	docker exec "$container_name" sh -c "echo -e '\nlisten = /run/$container_name/php-fpm.sock\nlisten.owner = www-data\nlisten.group = www-data\nlisten.mode = 0777' >> /usr/local/etc/php-fpm.d/www.conf"
	docker exec "$container_name" sh -c "rm -f /usr/local/etc/php-fpm.d/zz-docker.conf"

	find /home/web/conf.d/ -type f -name "*.conf" -exec sed -i "s#fastcgi_pass ${container_name}:9000;#fastcgi_pass unix:/run/${container_name}/php-fpm.sock;#g" {} \;

}






linux_ldnmp() {
  while true; do

	clear
	# send_stats "LDNMP寤虹珯"
	echo -e "${gl_huang}LDNMP寤虹珯"
	ldnmp_tato
	echo -e "${gl_huang}------------------------"
	echo -e "${gl_huang}1.   ${gl_bai}瀹夎LDNMP鐜 ${gl_huang}鈽?{gl_bai}                   ${gl_huang}2.   ${gl_bai}瀹夎WordPress ${gl_huang}鈽?{gl_bai}"
	echo -e "${gl_huang}3.   ${gl_bai}瀹夎Discuz璁哄潧                    ${gl_huang}4.   ${gl_bai}瀹夎鍙亾浜戞闈?
	echo -e "${gl_huang}5.   ${gl_bai}瀹夎鑻规灉CMS褰辫绔?                ${gl_huang}6.   ${gl_bai}瀹夎鐙鏁板彂鍗＄綉"
	echo -e "${gl_huang}7.   ${gl_bai}瀹夎flarum璁哄潧缃戠珯                ${gl_huang}8.   ${gl_bai}瀹夎typecho杞婚噺鍗氬缃戠珯"
	echo -e "${gl_huang}9.   ${gl_bai}瀹夎LinkStack鍏变韩閾炬帴骞冲彴         ${gl_huang}20.  ${gl_bai}鑷畾涔夊姩鎬佺珯鐐?
	echo -e "${gl_huang}------------------------"
	echo -e "${gl_huang}21.  ${gl_bai}浠呭畨瑁卬ginx ${gl_huang}鈽?{gl_bai}                     ${gl_huang}22.  ${gl_bai}绔欑偣閲嶅畾鍚?
	echo -e "${gl_huang}23.  ${gl_bai}绔欑偣鍙嶅悜浠ｇ悊-IP+绔彛 ${gl_huang}鈽?{gl_bai}            ${gl_huang}24.  ${gl_bai}绔欑偣鍙嶅悜浠ｇ悊-鍩熷悕"
	echo -e "${gl_huang}25.  ${gl_bai}瀹夎Bitwarden瀵嗙爜绠＄悊骞冲彴         ${gl_huang}26.  ${gl_bai}瀹夎Halo鍗氬缃戠珯"
	echo -e "${gl_huang}27.  ${gl_bai}瀹夎AI缁樼敾鎻愮ず璇嶇敓鎴愬櫒            ${gl_huang}28.  ${gl_bai}绔欑偣鍙嶅悜浠ｇ悊-璐熻浇鍧囪　"
	echo -e "${gl_huang}29.  ${gl_bai}Stream鍥涘眰浠ｇ悊杞彂                ${gl_huang}30.  ${gl_bai}鑷畾涔夐潤鎬佺珯鐐?
	echo -e "${gl_huang}------------------------"
	echo -e "${gl_huang}31.  ${gl_bai}绔欑偣鏁版嵁绠＄悊 ${gl_huang}鈽?{gl_bai}                    ${gl_huang}32.  ${gl_bai}澶囦唤鍏ㄧ珯鏁版嵁"
	echo -e "${gl_huang}33.  ${gl_bai}瀹氭椂杩滅▼澶囦唤                      ${gl_huang}34.  ${gl_bai}杩樺師鍏ㄧ珯鏁版嵁"
	echo -e "${gl_huang}------------------------"
	echo -e "${gl_huang}35.  ${gl_bai}闃叉姢LDNMP鐜                     ${gl_huang}36.  ${gl_bai}浼樺寲LDNMP鐜"
	echo -e "${gl_huang}37.  ${gl_bai}鏇存柊LDNMP鐜                     ${gl_huang}38.  ${gl_bai}鍗歌浇LDNMP鐜"
	echo -e "${gl_huang}------------------------"
	echo -e "${gl_huang}0.   ${gl_bai}杩斿洖涓昏彍鍗?
	echo -e "${gl_huang}------------------------${gl_bai}"
	read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice


	case $sub_choice in
	  1)
	  ldnmp_install_status_one
	  ldnmp_install_all
		;;
	  2)
	  ldnmp_wp
		;;

	  3)
	  clear
	  # Discuz璁哄潧
	  webname="Discuz璁哄潧"
	  send_stats "瀹夎$webname"
	  echo "寮€濮嬮儴缃?$webname"
	  add_yuming
	  repeat_add_yuming
	  ldnmp_install_status


	  install_ssltls
	  certs_status
	  add_db


	  wget -O /home/web/conf.d/map.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/map.conf
	  wget -O /home/web/conf.d/$yuming.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/discuz.com.conf
	  sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

	  nginx_http_on

	  cd /home/web/html
	  mkdir $yuming
	  cd $yuming
	  wget -O latest.zip ${gh_proxy}github.com/kejilion/Website_source_code/raw/main/Discuz_X3.5_SC_UTF8_20250901.zip
	  unzip latest.zip
	  rm latest.zip

	  restart_ldnmp


	  ldnmp_web_on
	  echo "鏁版嵁搴撳湴鍧€: mysql"
	  echo "鏁版嵁搴撳悕: $dbname"
	  echo "鐢ㄦ埛鍚? $dbuse"
	  echo "瀵嗙爜: $dbusepasswd"
	  echo "琛ㄥ墠缂€: discuz_"


		;;

	  4)
	  clear
	  # 鍙亾浜戞闈?
	  webname="鍙亾浜戞闈?
	  send_stats "瀹夎$webname"
	  echo "寮€濮嬮儴缃?$webname"
	  add_yuming
	  repeat_add_yuming
	  ldnmp_install_status

	  install_ssltls
	  certs_status
	  add_db

	  wget -O /home/web/conf.d/map.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/map.conf
	  wget -O /home/web/conf.d/$yuming.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/kdy.com.conf
	  sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

	  nginx_http_on

	  cd /home/web/html
	  mkdir $yuming
	  cd $yuming
	  wget -O latest.zip ${gh_proxy}github.com/kalcaddle/kodbox/archive/refs/tags/1.50.02.zip
	  unzip -o latest.zip
	  rm latest.zip
	  mv /home/web/html/$yuming/kodbox* /home/web/html/$yuming/kodbox
	  restart_ldnmp

	  ldnmp_web_on
	  echo "鏁版嵁搴撳湴鍧€: mysql"
	  echo "鐢ㄦ埛鍚? $dbuse"
	  echo "瀵嗙爜: $dbusepasswd"
	  echo "鏁版嵁搴撳悕: $dbname"
	  echo "redis涓绘満: redis"

		;;

	  5)
	  clear
	  # 鑻规灉CMS
	  webname="鑻规灉CMS"
	  send_stats "瀹夎$webname"
	  echo "寮€濮嬮儴缃?$webname"
	  add_yuming
	  repeat_add_yuming
	  ldnmp_install_status



	  install_ssltls
	  certs_status
	  add_db

	  wget -O /home/web/conf.d/map.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/map.conf
	  wget -O /home/web/conf.d/$yuming.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/maccms.com.conf
	  sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

	  nginx_http_on

	  cd /home/web/html
	  mkdir $yuming
	  cd $yuming
	  # wget ${gh_proxy}github.com/magicblack/maccms_down/raw/master/maccms10.zip && unzip maccms10.zip && rm maccms10.zip
	  wget ${gh_proxy}github.com/magicblack/maccms_down/raw/master/maccms10.zip && unzip maccms10.zip && mv maccms10-*/* . && rm -r maccms10-* && rm maccms10.zip
	  cd /home/web/html/$yuming/template/ && wget ${gh_proxy}github.com/kejilion/Website_source_code/raw/main/DYXS2.zip && unzip DYXS2.zip && rm /home/web/html/$yuming/template/DYXS2.zip
	  cp /home/web/html/$yuming/template/DYXS2/asset/admin/Dyxs2.php /home/web/html/$yuming/application/admin/controller
	  cp /home/web/html/$yuming/template/DYXS2/asset/admin/dycms.html /home/web/html/$yuming/application/admin/view/system
	  mv /home/web/html/$yuming/admin.php /home/web/html/$yuming/vip.php && wget -O /home/web/html/$yuming/application/extra/maccms.php ${gh_proxy}raw.githubusercontent.com/kejilion/Website_source_code/main/maccms.php

	  restart_ldnmp


	  ldnmp_web_on
	  echo "鏁版嵁搴撳湴鍧€: mysql"
	  echo "鏁版嵁搴撶鍙? 3306"
	  echo "鏁版嵁搴撳悕: $dbname"
	  echo "鐢ㄦ埛鍚? $dbuse"
	  echo "瀵嗙爜: $dbusepasswd"
	  echo "鏁版嵁搴撳墠缂€: mac_"
	  echo "------------------------"
	  echo "瀹夎鎴愬姛鍚庣櫥褰曞悗鍙板湴鍧€"
	  echo "https://$yuming/vip.php"

		;;

	  6)
	  clear
	  # 鐙剼鏁板崱
	  webname="鐙剼鏁板崱"
	  send_stats "瀹夎$webname"
	  echo "寮€濮嬮儴缃?$webname"
	  add_yuming
	  repeat_add_yuming
	  ldnmp_install_status



	  install_ssltls
	  certs_status
	  add_db


	  wget -O /home/web/conf.d/map.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/map.conf
	  wget -O /home/web/conf.d/$yuming.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/dujiaoka.com.conf
	  sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

	  nginx_http_on

	  cd /home/web/html
	  mkdir $yuming
	  cd $yuming
	  wget ${gh_proxy}github.com/assimon/dujiaoka/releases/download/2.0.6/2.0.6-antibody.tar.gz && tar -zxvf 2.0.6-antibody.tar.gz && rm 2.0.6-antibody.tar.gz

	  restart_ldnmp


	  ldnmp_web_on
	  echo "鏁版嵁搴撳湴鍧€: mysql"
	  echo "鏁版嵁搴撶鍙? 3306"
	  echo "鏁版嵁搴撳悕: $dbname"
	  echo "鐢ㄦ埛鍚? $dbuse"
	  echo "瀵嗙爜: $dbusepasswd"
	  echo ""
	  echo "redis鍦板潃: redis"
	  echo "redis瀵嗙爜: 榛樿涓嶅～鍐?
	  echo "redis绔彛: 6379"
	  echo ""
	  echo "缃戠珯url: https://$yuming"
	  echo "鍚庡彴鐧诲綍璺緞: /admin"
	  echo "------------------------"
	  echo "鐢ㄦ埛鍚? admin"
	  echo "瀵嗙爜: admin"
	  echo "------------------------"
	  echo "鐧诲綍鏃跺彸涓婅濡傛灉鍑虹幇绾㈣壊error0璇蜂娇鐢ㄥ涓嬪懡浠? "
	  echo "鎴戜篃寰堟皵鎰ょ嫭瑙掓暟鍗′负鍟ヨ繖涔堥夯鐑︼紝浼氭湁杩欐牱鐨勯棶棰橈紒"
	  echo "sed -i 's/ADMIN_HTTPS=false/ADMIN_HTTPS=true/g' /home/web/html/$yuming/dujiaoka/.env"

		;;

	  7)
	  clear
	  # flarum璁哄潧
	  webname="flarum璁哄潧"
	  send_stats "瀹夎$webname"
	  echo "寮€濮嬮儴缃?$webname"
	  add_yuming
	  repeat_add_yuming
	  ldnmp_install_status



	  install_ssltls
	  certs_status
	  add_db

	  wget -O /home/web/conf.d/map.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/map.conf
	  wget -O /home/web/conf.d/$yuming.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/flarum.com.conf
	  sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf


	  nginx_http_on

	  docker exec php rm -f /usr/local/etc/php/conf.d/optimized_php.ini

	  cd /home/web/html
	  mkdir $yuming
	  cd $yuming

	  docker exec php sh -c "php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\""
	  docker exec php sh -c "php composer-setup.php"
	  docker exec php sh -c "php -r \"unlink('composer-setup.php');\""
	  docker exec php sh -c "mv composer.phar /usr/local/bin/composer"

	  docker exec php composer create-project flarum/flarum /var/www/html/$yuming
	  docker exec php sh -c "cd /var/www/html/$yuming && composer require flarum-lang/chinese-simplified"
	  docker exec php sh -c "cd /var/www/html/$yuming && composer require flarum/extension-manager:*"
	  docker exec php sh -c "cd /var/www/html/$yuming && composer require fof/polls"
	  docker exec php sh -c "cd /var/www/html/$yuming && composer require fof/sitemap"
	  docker exec php sh -c "cd /var/www/html/$yuming && composer require fof/oauth"
	  docker exec php sh -c "cd /var/www/html/$yuming && composer require fof/best-answer:*"
	  docker exec php sh -c "cd /var/www/html/$yuming && composer require fof/upload"
	  docker exec php sh -c "cd /var/www/html/$yuming && composer require fof/gamification"
	  docker exec php sh -c "cd /var/www/html/$yuming && composer require fof/byobu:*"
	  docker exec php sh -c "cd /var/www/html/$yuming && composer require v17development/flarum-seo"
	  docker exec php sh -c "cd /var/www/html/$yuming && composer require clarkwinkelmann/flarum-ext-emojionearea"


	  restart_ldnmp


	  ldnmp_web_on
	  echo "鏁版嵁搴撳湴鍧€: mysql"
	  echo "鏁版嵁搴撳悕: $dbname"
	  echo "鐢ㄦ埛鍚? $dbuse"
	  echo "瀵嗙爜: $dbusepasswd"
	  echo "琛ㄥ墠缂€: flarum_"
	  echo "绠＄悊鍛樹俊鎭嚜琛岃缃?

		;;

	  8)
	  clear
	  # typecho
	  webname="typecho"
	  send_stats "瀹夎$webname"
	  echo "寮€濮嬮儴缃?$webname"
	  add_yuming
	  repeat_add_yuming
	  ldnmp_install_status




	  install_ssltls
	  certs_status
	  add_db

	  wget -O /home/web/conf.d/map.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/map.conf
	  wget -O /home/web/conf.d/$yuming.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/typecho.com.conf
	  sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

	  nginx_http_on

	  cd /home/web/html
	  mkdir $yuming
	  cd $yuming
	  wget -O latest.zip ${gh_proxy}github.com/typecho/typecho/releases/latest/download/typecho.zip
	  unzip latest.zip
	  rm latest.zip

	  restart_ldnmp


	  clear
	  ldnmp_web_on
	  echo "鏁版嵁搴撳墠缂€: typecho_"
	  echo "鏁版嵁搴撳湴鍧€: mysql"
	  echo "鐢ㄦ埛鍚? $dbuse"
	  echo "瀵嗙爜: $dbusepasswd"
	  echo "鏁版嵁搴撳悕: $dbname"

		;;


	  9)
	  clear
	  # LinkStack
	  webname="LinkStack"
	  send_stats "瀹夎$webname"
	  echo "寮€濮嬮儴缃?$webname"
	  add_yuming
	  repeat_add_yuming
	  ldnmp_install_status


	  install_ssltls
	  certs_status
	  add_db

	  wget -O /home/web/conf.d/map.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/map.conf
	  wget -O /home/web/conf.d/$yuming.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/refs/heads/main/index_php.conf
	  sed -i "s|/var/www/html/yuming.com/|/var/www/html/yuming.com/linkstack|g" /home/web/conf.d/$yuming.conf
	  sed -i "s|yuming.com|$yuming|g" /home/web/conf.d/$yuming.conf

	  nginx_http_on

	  cd /home/web/html
	  mkdir $yuming
	  cd $yuming
	  wget -O latest.zip ${gh_proxy}github.com/linkstackorg/linkstack/releases/latest/download/linkstack.zip
	  unzip latest.zip
	  rm latest.zip

	  restart_ldnmp


	  clear
	  ldnmp_web_on
	  echo "鏁版嵁搴撳湴鍧€: mysql"
	  echo "鏁版嵁搴撶鍙? 3306"
	  echo "鏁版嵁搴撳悕: $dbname"
	  echo "鐢ㄦ埛鍚? $dbuse"
	  echo "瀵嗙爜: $dbusepasswd"
		;;

	  20)
	  clear
	  webname="PHP鍔ㄦ€佺珯鐐?
	  send_stats "瀹夎$webname"
	  echo "寮€濮嬮儴缃?$webname"
	  add_yuming
	  repeat_add_yuming
	  ldnmp_install_status

	  install_ssltls
	  certs_status
	  add_db

	  wget -O /home/web/conf.d/map.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/map.conf
	  wget -O /home/web/conf.d/$yuming.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/index_php.conf
	  sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

	  nginx_http_on

	  cd /home/web/html
	  mkdir $yuming
	  cd $yuming

	  clear
	  echo -e "[${gl_huang}1/6${gl_bai}] 涓婁紶PHP婧愮爜"
	  echo "-------------"
	  echo "鐩墠鍙厑璁镐笂浼爖ip鏍煎紡鐨勬簮鐮佸寘锛岃灏嗘簮鐮佸寘鏀惧埌/home/web/html/${yuming}鐩綍涓?
	  read -e -p "涔熷彲浠ヨ緭鍏ヤ笅杞介摼鎺ワ紝杩滅▼涓嬭浇婧愮爜鍖咃紝鐩存帴鍥炶溅灏嗚烦杩囪繙绋嬩笅杞斤細 " url_download

	  if [ -n "$url_download" ]; then
		  wget "$url_download"
	  fi

	  unzip $(ls -t *.zip | head -n 1)
	  rm -f $(ls -t *.zip | head -n 1)

	  clear
	  echo -e "[${gl_huang}2/6${gl_bai}] index.php鎵€鍦ㄨ矾寰?
	  echo "-------------"
	  # find "$(realpath .)" -name "index.php" -print
	  find "$(realpath .)" -name "index.php" -print | xargs -I {} dirname {}

	  read -e -p "璇疯緭鍏ndex.php鐨勮矾寰勶紝绫讳技锛?home/web/html/$yuming/wordpress/锛夛細 " index_lujing

	  sed -i "s#root /var/www/html/$yuming/#root $index_lujing#g" /home/web/conf.d/$yuming.conf
	  sed -i "s#/home/web/#/var/www/#g" /home/web/conf.d/$yuming.conf

	  clear
	  echo -e "[${gl_huang}3/6${gl_bai}] 璇烽€夋嫨PHP鐗堟湰"
	  echo "-------------"
	  read -e -p "1. php鏈€鏂扮増 | 2. php7.4 : " pho_v
	  case "$pho_v" in
		1)
		  sed -i "s#php:9000#php:9000#g" /home/web/conf.d/$yuming.conf
		  local PHP_Version="php"
		  ;;
		2)
		  sed -i "s#php:9000#php74:9000#g" /home/web/conf.d/$yuming.conf
		  local PHP_Version="php74"
		  ;;
		*)
		  echo "鏃犳晥鐨勯€夋嫨锛岃閲嶆柊杈撳叆銆?
		  ;;
	  esac


	  clear
	  echo -e "[${gl_huang}4/6${gl_bai}] 瀹夎鎸囧畾鎵╁睍"
	  echo "-------------"
	  echo "宸茬粡瀹夎鐨勬墿灞?
	  docker exec php php -m

	  read -e -p "$(echo -e "杈撳叆闇€瑕佸畨瑁呯殑鎵╁睍鍚嶇О锛屽 ${gl_huang}SourceGuardian imap ftp${gl_bai} 绛夌瓑銆傜洿鎺ュ洖杞﹀皢璺宠繃瀹夎 锛?")" php_extensions
	  if [ -n "$php_extensions" ]; then
		  docker exec $PHP_Version install-php-extensions $php_extensions
	  fi


	  clear
	  echo -e "[${gl_huang}5/6${gl_bai}] 缂栬緫绔欑偣閰嶇疆"
	  echo "-------------"
	  echo "鎸変换鎰忛敭缁х画锛屽彲浠ヨ缁嗚缃珯鐐归厤缃紝濡備吉闈欐€佺瓑鍐呭"
	  read -n 1 -s -r -p ""
	  install nano
	  nano /home/web/conf.d/$yuming.conf


	  clear
	  echo -e "[${gl_huang}6/6${gl_bai}] 鏁版嵁搴撶鐞?
	  echo "-------------"
	  read -e -p "1. 鎴戞惌寤烘柊绔?       2. 鎴戞惌寤鸿€佺珯鏈夋暟鎹簱澶囦唤锛?" use_db
	  case $use_db in
		  1)
			  echo
			  ;;
		  2)
			  echo "鏁版嵁搴撳浠藉繀椤绘槸.gz缁撳熬鐨勫帇缂╁寘銆傝鏀惧埌/home/鐩綍涓嬶紝鏀寔瀹濆/1panel澶囦唤鏁版嵁瀵煎叆銆?
			  read -e -p "涔熷彲浠ヨ緭鍏ヤ笅杞介摼鎺ワ紝杩滅▼涓嬭浇澶囦唤鏁版嵁锛岀洿鎺ュ洖杞﹀皢璺宠繃杩滅▼涓嬭浇锛?" url_download_db

			  cd /home/
			  if [ -n "$url_download_db" ]; then
				  wget "$url_download_db"
			  fi
			  gunzip $(ls -t *.gz | head -n 1)
			  latest_sql=$(ls -t *.sql | head -n 1)
			  dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
			  docker exec -i mysql mysql -u root -p"$dbrootpasswd" $dbname < "/home/$latest_sql"
			  echo "鏁版嵁搴撳鍏ョ殑琛ㄦ暟鎹?
			  docker exec -i mysql mysql -u root -p"$dbrootpasswd" -e "USE $dbname; SHOW TABLES;"
			  rm -f *.sql
			  echo "鏁版嵁搴撳鍏ュ畬鎴?
			  ;;
		  *)
			  echo
			  ;;
	  esac

	  docker exec php rm -f /usr/local/etc/php/conf.d/optimized_php.ini

	  restart_ldnmp
	  ldnmp_web_on
	  prefix="web$(shuf -i 10-99 -n 1)_"
	  echo "鏁版嵁搴撳湴鍧€: mysql"
	  echo "鏁版嵁搴撳悕: $dbname"
	  echo "鐢ㄦ埛鍚? $dbuse"
	  echo "瀵嗙爜: $dbusepasswd"
	  echo "琛ㄥ墠缂€: $prefix"
	  echo "绠＄悊鍛樼櫥褰曚俊鎭嚜琛岃缃?

		;;


	  21)
	  ldnmp_install_status_one
	  nginx_install_all
		;;

	  22)
	  clear
	  webname="绔欑偣閲嶅畾鍚?
	  send_stats "瀹夎$webname"
	  echo "寮€濮嬮儴缃?$webname"
	  add_yuming
	  read -e -p "璇疯緭鍏ヨ烦杞煙鍚? " reverseproxy
	  nginx_install_status



	  install_ssltls
	  certs_status


	  wget -O /home/web/conf.d/$yuming.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/rewrite.conf
	  sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf
	  sed -i "s/baidu.com/$reverseproxy/g" /home/web/conf.d/$yuming.conf

	  nginx_http_on

	  docker exec nginx nginx -s reload

	  nginx_web_on


		;;

	  23)
	  ldnmp_Proxy
	  find_container_by_host_port "$port"
	  if [ -z "$docker_name" ]; then
		close_port "$port"
		echo "宸查樆姝P+绔彛璁块棶璇ユ湇鍔?
	  else
	  	ip_address
		close_port "$port"
		block_container_port "$docker_name" "$ipv4_address"
	  fi

		;;

	  24)
	  clear
	  webname="鍙嶅悜浠ｇ悊-鍩熷悕"
	  send_stats "瀹夎$webname"
	  echo "寮€濮嬮儴缃?$webname"
	  add_yuming
	  echo -e "鍩熷悕鏍煎紡: ${gl_huang}google.com${gl_bai}"
	  read -e -p "璇疯緭鍏ヤ綘鐨勫弽浠ｅ煙鍚? " fandai_yuming
	  nginx_install_status

	  install_ssltls
	  certs_status


	  wget -O /home/web/conf.d/$yuming.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/reverse-proxy-domain.conf
	  sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf
	  sed -i "s|fandaicom|$fandai_yuming|g" /home/web/conf.d/$yuming.conf


	  nginx_http_on

	  docker exec nginx nginx -s reload

	  nginx_web_on

		;;


	  25)
	  clear
	  webname="Bitwarden"
	  send_stats "瀹夎$webname"
	  echo "寮€濮嬮儴缃?$webname"
	  add_yuming

	  docker run -d \
		--name bitwarden \
		--restart=always \
		-p 3280:80 \
		-v /home/web/html/$yuming/bitwarden/data:/data \
		vaultwarden/server

	  duankou=3280
	  ldnmp_Proxy ${yuming} 127.0.0.1 $duankou


		;;

	  26)
	  clear
	  webname="halo"
	  send_stats "瀹夎$webname"
	  echo "寮€濮嬮儴缃?$webname"
	  add_yuming

	  docker run -d --name halo --restart=always -p 8010:8090 -v /home/web/html/$yuming/.halo2:/root/.halo2 halohub/halo:2

	  duankou=8010
	  ldnmp_Proxy ${yuming} 127.0.0.1 $duankou

		;;

	  27)
	  clear
	  webname="AI缁樼敾鎻愮ず璇嶇敓鎴愬櫒"
	  send_stats "瀹夎$webname"
	  echo "寮€濮嬮儴缃?$webname"
	  add_yuming
	  nginx_install_status


	  install_ssltls
	  certs_status

	  wget -O /home/web/conf.d/$yuming.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/html.conf
	  sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

	  nginx_http_on

	  cd /home/web/html
	  mkdir $yuming
	  cd $yuming

	  wget ${gh_proxy}github.com/kejilion/Website_source_code/raw/refs/heads/main/ai_prompt_generator.zip
	  unzip $(ls -t *.zip | head -n 1)
	  rm -f $(ls -t *.zip | head -n 1)

	  docker exec nginx chmod -R nginx:nginx /var/www/html
	  docker exec nginx nginx -s reload

	  nginx_web_on

		;;

	  28)
	  ldnmp_Proxy_backend
		;;


	  29)
	  stream_panel
		;;

	  30)
	  clear
	  webname="闈欐€佺珯鐐?
	  send_stats "瀹夎$webname"
	  echo "寮€濮嬮儴缃?$webname"
	  add_yuming
	  repeat_add_yuming
	  nginx_install_status


	  install_ssltls
	  certs_status

	  wget -O /home/web/conf.d/$yuming.conf ${gh_proxy}raw.githubusercontent.com/kejilion/nginx/main/html.conf
	  sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

	  nginx_http_on

	  cd /home/web/html
	  mkdir $yuming
	  cd $yuming


	  clear
	  echo -e "[${gl_huang}1/2${gl_bai}] 涓婁紶闈欐€佹簮鐮?
	  echo "-------------"
	  echo "鐩墠鍙厑璁镐笂浼爖ip鏍煎紡鐨勬簮鐮佸寘锛岃灏嗘簮鐮佸寘鏀惧埌/home/web/html/${yuming}鐩綍涓?
	  read -e -p "涔熷彲浠ヨ緭鍏ヤ笅杞介摼鎺ワ紝杩滅▼涓嬭浇婧愮爜鍖咃紝鐩存帴鍥炶溅灏嗚烦杩囪繙绋嬩笅杞斤細 " url_download

	  if [ -n "$url_download" ]; then
		  wget "$url_download"
	  fi

	  unzip $(ls -t *.zip | head -n 1)
	  rm -f $(ls -t *.zip | head -n 1)

	  clear
	  echo -e "[${gl_huang}2/2${gl_bai}] index.html鎵€鍦ㄨ矾寰?
	  echo "-------------"
	  # find "$(realpath .)" -name "index.html" -print
	  find "$(realpath .)" -name "index.html" -print | xargs -I {} dirname {}

	  read -e -p "璇疯緭鍏ndex.html鐨勮矾寰勶紝绫讳技锛?home/web/html/$yuming/index/锛夛細 " index_lujing

	  sed -i "s#root /var/www/html/$yuming/#root $index_lujing#g" /home/web/conf.d/$yuming.conf
	  sed -i "s#/home/web/#/var/www/#g" /home/web/conf.d/$yuming.conf

	  docker exec nginx chmod -R nginx:nginx /var/www/html
	  docker exec nginx nginx -s reload

	  nginx_web_on

		;;







	31)
	  ldnmp_web_status
	  ;;


	32)
	  clear
	  send_stats "LDNMP鐜澶囦唤"

	  local backup_filename="web_$(date +"%Y%m%d%H%M%S").tar.gz"
	  echo -e "${gl_kjlan}姝ｅ湪澶囦唤 $backup_filename ...${gl_bai}"
	  cd /home/ && tar czvf "$backup_filename" web

	  while true; do
		clear
		echo "澶囦唤鏂囦欢宸插垱寤? /home/$backup_filename"
		read -e -p "瑕佷紶閫佸浠芥暟鎹埌杩滅▼鏈嶅姟鍣ㄥ悧锛?Y/N): " choice
		case "$choice" in
		  [Yy])
			read -e -p "璇疯緭鍏ヨ繙绔湇鍔″櫒IP:  " remote_ip
			read -e -p "鐩爣鏈嶅姟鍣⊿SH绔彛 [榛樿22]: " TARGET_PORT
			local TARGET_PORT=${TARGET_PORT:-22}
			if [ -z "$remote_ip" ]; then
			  echo "閿欒: 璇疯緭鍏ヨ繙绔湇鍔″櫒IP銆?
			  continue
			fi
			local latest_tar=$(ls -t /home/*.tar.gz | head -1)
			if [ -n "$latest_tar" ]; then
			  ssh-keygen -f "/root/.ssh/known_hosts" -R "$remote_ip"
			  sleep 2  # 娣诲姞绛夊緟鏃堕棿
			  scp -P "$TARGET_PORT" -o StrictHostKeyChecking=no "$latest_tar" "root@$remote_ip:/home/"
			  echo "鏂囦欢宸蹭紶閫佽嚦杩滅▼鏈嶅姟鍣╤ome鐩綍銆?
			else
			  echo "鏈壘鍒拌浼犻€佺殑鏂囦欢銆?
			fi
			break
			;;
		  [Nn])
			break
			;;
		  *)
			echo "鏃犳晥鐨勯€夋嫨锛岃杈撳叆 Y 鎴?N銆?
			;;
		esac
	  done
	  ;;

	33)
	  clear
	  send_stats "瀹氭椂杩滅▼澶囦唤"
	  read -e -p "杈撳叆杩滅▼鏈嶅姟鍣↖P: " useip
	  read -e -p "杈撳叆杩滅▼鏈嶅姟鍣ㄥ瘑鐮? " usepasswd

	  cd ~
	  wget -O ${useip}_beifen.sh ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/beifen.sh > /dev/null 2>&1
	  chmod +x ${useip}_beifen.sh

	  sed -i "s/0.0.0.0/$useip/g" ${useip}_beifen.sh
	  sed -i "s/123456/$usepasswd/g" ${useip}_beifen.sh

	  echo "------------------------"
	  echo "1. 姣忓懆澶囦唤                 2. 姣忓ぉ澶囦唤"
	  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " dingshi

	  case $dingshi in
		  1)
			  check_crontab_installed
			  read -e -p "閫夋嫨姣忓懆澶囦唤鐨勬槦鏈熷嚑 (0-6锛?浠ｈ〃鏄熸湡鏃?: " weekday
			  (crontab -l ; echo "0 0 * * $weekday ./${useip}_beifen.sh") | crontab - > /dev/null 2>&1
			  ;;
		  2)
			  check_crontab_installed
			  read -e -p "閫夋嫨姣忓ぉ澶囦唤鐨勬椂闂达紙灏忔椂锛?-23锛? " hour
			  (crontab -l ; echo "0 $hour * * * ./${useip}_beifen.sh") | crontab - > /dev/null 2>&1
			  ;;
		  *)
			  break  # 璺冲嚭
			  ;;
	  esac

	  install sshpass

	  ;;

	34)
	  root_use
	  send_stats "LDNMP鐜杩樺師"
	  echo "鍙敤鐨勭珯鐐瑰浠?
	  echo "-------------------------"
	  ls -lt /home/*.gz | awk '{print $NF}'
	  echo ""
	  read -e -p  "鍥炶溅閿繕鍘熸渶鏂扮殑澶囦唤锛岃緭鍏ュ浠芥枃浠跺悕杩樺師鎸囧畾鐨勫浠斤紝杈撳叆0閫€鍑猴細" filename

	  if [ "$filename" == "0" ]; then
		  break_end
		  linux_ldnmp
	  fi

	  # 濡傛灉鐢ㄦ埛娌℃湁杈撳叆鏂囦欢鍚嶏紝浣跨敤鏈€鏂扮殑鍘嬬缉鍖?
	  if [ -z "$filename" ]; then
		  local filename=$(ls -t /home/*.tar.gz | head -1)
	  fi

	  if [ -n "$filename" ]; then
		  cd /home/web/ > /dev/null 2>&1
		  docker compose down > /dev/null 2>&1
		  rm -rf /home/web > /dev/null 2>&1

		  echo -e "${gl_kjlan}姝ｅ湪瑙ｅ帇 $filename ...${gl_bai}"
		  cd /home/ && tar -xzf "$filename"

		  install_dependency
		  install_docker
		  install_certbot
		  install_ldnmp
	  else
		  echo "娌℃湁鎵惧埌鍘嬬缉鍖呫€?
	  fi

	  ;;

	35)
		web_security
		;;

	36)
		web_optimization
		;;


	37)
	  root_use
	  while true; do
		  clear
		  send_stats "鏇存柊LDNMP鐜"
		  echo "鏇存柊LDNMP鐜"
		  echo "------------------------"
		  ldnmp_v
		  echo "鍙戠幇鏂扮増鏈殑缁勪欢"
		  echo "------------------------"
		  check_docker_image_update nginx
		  if [ -n "$update_status" ]; then
			echo -e "${gl_huang}nginx $update_status${gl_bai}"
		  fi
		  check_docker_image_update php
		  if [ -n "$update_status" ]; then
			echo -e "${gl_huang}php $update_status${gl_bai}"
		  fi
		  check_docker_image_update mysql
		  if [ -n "$update_status" ]; then
			echo -e "${gl_huang}mysql $update_status${gl_bai}"
		  fi
		  check_docker_image_update redis
		  if [ -n "$update_status" ]; then
			echo -e "${gl_huang}redis $update_status${gl_bai}"
		  fi
		  echo "------------------------"
		  echo
		  echo "1. 鏇存柊nginx               2. 鏇存柊mysql              3. 鏇存柊php              4. 鏇存柊redis"
		  echo "------------------------"
		  echo "5. 鏇存柊瀹屾暣鐜"
		  echo "------------------------"
		  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
		  echo "------------------------"
		  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice
		  case $sub_choice in
			  1)
			  nginx_upgrade

				  ;;

			  2)
			  local ldnmp_pods="mysql"
			  read -e -p "璇疯緭鍏?{ldnmp_pods}鐗堟湰鍙?锛堝: 8.0 8.3 8.4 9.0锛夛紙鍥炶溅鑾峰彇鏈€鏂扮増锛? " version
			  local version=${version:-latest}

			  cd /home/web/
			  cp /home/web/docker-compose.yml /home/web/docker-compose1.yml
			  sed -i "s/image: mysql/image: mysql:${version}/" /home/web/docker-compose.yml
			  docker rm -f $ldnmp_pods
			  docker images --filter=reference="$ldnmp_pods*" -q | xargs docker rmi > /dev/null 2>&1
			  docker compose up -d --force-recreate $ldnmp_pods
			  docker restart $ldnmp_pods
			  cp /home/web/docker-compose1.yml /home/web/docker-compose.yml
			  send_stats "鏇存柊$ldnmp_pods"
			  echo "鏇存柊${ldnmp_pods}瀹屾垚"

				  ;;
			  3)
			  local ldnmp_pods="php"
			  read -e -p "璇疯緭鍏?{ldnmp_pods}鐗堟湰鍙?锛堝: 7.4 8.0 8.1 8.2 8.3锛夛紙鍥炶溅鑾峰彇鏈€鏂扮増锛? " version
			  local version=${version:-8.3}
			  cd /home/web/
			  cp /home/web/docker-compose.yml /home/web/docker-compose1.yml
			  sed -i "s/kjlion\///g" /home/web/docker-compose.yml > /dev/null 2>&1
			  sed -i "s/image: php:fpm-alpine/image: php:${version}-fpm-alpine/" /home/web/docker-compose.yml
			  docker rm -f $ldnmp_pods
			  docker images --filter=reference="$ldnmp_pods*" -q | xargs docker rmi > /dev/null 2>&1
  			  docker images --filter=reference="kjlion/${ldnmp_pods}*" -q | xargs docker rmi > /dev/null 2>&1
			  docker compose up -d --force-recreate $ldnmp_pods
			  docker exec php chown -R www-data:www-data /var/www/html

			  run_command docker exec php sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories > /dev/null 2>&1

			  docker exec php apk update
			  curl -sL ${gh_proxy}github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o /usr/local/bin/install-php-extensions
			  docker exec php mkdir -p /usr/local/bin/
			  docker cp /usr/local/bin/install-php-extensions php:/usr/local/bin/
			  docker exec php chmod +x /usr/local/bin/install-php-extensions
			  docker exec php install-php-extensions mysqli pdo_mysql gd intl zip exif bcmath opcache redis imagick soap


			  docker exec php sh -c 'echo "upload_max_filesize=50M " > /usr/local/etc/php/conf.d/uploads.ini' > /dev/null 2>&1
			  docker exec php sh -c 'echo "post_max_size=50M " > /usr/local/etc/php/conf.d/post.ini' > /dev/null 2>&1
			  docker exec php sh -c 'echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory.ini' > /dev/null 2>&1
			  docker exec php sh -c 'echo "max_execution_time=1200" > /usr/local/etc/php/conf.d/max_execution_time.ini' > /dev/null 2>&1
			  docker exec php sh -c 'echo "max_input_time=600" > /usr/local/etc/php/conf.d/max_input_time.ini' > /dev/null 2>&1
			  docker exec php sh -c 'echo "max_input_vars=5000" > /usr/local/etc/php/conf.d/max_input_vars.ini' > /dev/null 2>&1

			  fix_phpfpm_con $ldnmp_pods

			  docker restart $ldnmp_pods > /dev/null 2>&1
			  cp /home/web/docker-compose1.yml /home/web/docker-compose.yml
			  send_stats "鏇存柊$ldnmp_pods"
			  echo "鏇存柊${ldnmp_pods}瀹屾垚"

				  ;;
			  4)
			  local ldnmp_pods="redis"
			  cd /home/web/
			  docker rm -f $ldnmp_pods
			  docker images --filter=reference="$ldnmp_pods*" -q | xargs docker rmi > /dev/null 2>&1
			  docker compose up -d --force-recreate $ldnmp_pods
			  docker restart $ldnmp_pods > /dev/null 2>&1
			  send_stats "鏇存柊$ldnmp_pods"
			  echo "鏇存柊${ldnmp_pods}瀹屾垚"

				  ;;
			  5)
				read -e -p "$(echo -e "${gl_huang}鎻愮ず: ${gl_bai}闀挎椂闂翠笉鏇存柊鐜鐨勭敤鎴凤紝璇锋厧閲嶆洿鏂癓DNMP鐜锛屼細鏈夋暟鎹簱鏇存柊澶辫触鐨勯闄┿€傜‘瀹氭洿鏂癓DNMP鐜鍚楋紵(Y/N): ")" choice
				case "$choice" in
				  [Yy])
					send_stats "瀹屾暣鏇存柊LDNMP鐜"
					cd /home/web/
					docker compose down --rmi all

					install_dependency
					install_docker
					install_certbot
					install_ldnmp
					;;
				  *)
					;;
				esac
				  ;;
			  *)
				  break
				  ;;
		  esac
		  break_end
	  done


	  ;;

	38)
		root_use
		send_stats "鍗歌浇LDNMP鐜"
		read -e -p "$(echo -e "${gl_hong}寮虹儓寤鸿锛?{gl_bai}鍏堝浠藉叏閮ㄧ綉绔欐暟鎹紝鍐嶅嵏杞絃DNMP鐜銆傜‘瀹氬垹闄ゆ墍鏈夌綉绔欐暟鎹悧锛?Y/N): ")" choice
		case "$choice" in
		  [Yy])
			cd /home/web/
			docker compose down --rmi all
			docker compose -f docker-compose.phpmyadmin.yml down > /dev/null 2>&1
			docker compose -f docker-compose.phpmyadmin.yml down --rmi all > /dev/null 2>&1
			rm -rf /home/web
			;;
		  [Nn])

			;;
		  *)
			echo "鏃犳晥鐨勯€夋嫨锛岃杈撳叆 Y 鎴?N銆?
			;;
		esac
		;;

	0)
		kejilion
	  ;;

	*)
		echo "鏃犳晥鐨勮緭鍏?"
	esac
	break_end

  done

}






moltbot_menu() {
	local app_id="114"

	send_stats "clawdbot/moltbot绠＄悊"

	check_openclaw_update() {
		if ! command -v npm >/dev/null 2>&1; then
			return 1
		fi

		# 鍔犱笂 --no-update-notifier锛屽苟纭繚閿欒閲嶅畾鍚戜綅缃纭?
		local_version=$(npm list -g openclaw --depth=0 --no-update-notifier 2>/dev/null | grep openclaw | awk '{print $NF}' | sed 's/^.*@//')

		if [ -z "$local_version" ]; then
			return 1
		fi

		remote_version=$(npm view openclaw version --no-update-notifier 2>/dev/null)

		if [ -z "$remote_version" ]; then
			return 1
		fi

		if [ "$local_version" != "$remote_version" ]; then
			echo "${gl_huang}妫€娴嬪埌鏂扮増鏈?$remote_version${gl_bai}"
		else
			echo "${gl_lv}褰撳墠鐗堟湰宸叉槸鏈€鏂?$local_version${gl_bai}"
		fi
	}


	get_install_status() {
		if command -v openclaw >/dev/null 2>&1; then
			echo "${gl_lv}宸插畨瑁?{gl_bai}"
		else
			echo "${gl_hui}鏈畨瑁?{gl_bai}"
		fi
	}

	get_running_status() {
		if pgrep -f "openclaw-gatewa" >/dev/null 2>&1; then
			echo "${gl_lv}杩愯涓?{gl_bai}"
		else
			echo "${gl_hui}鏈繍琛?{gl_bai}"
		fi
	}


	show_menu() {


		clear

		local install_status=$(get_install_status)
		local running_status=$(get_running_status)
		local update_message=$(check_openclaw_update)

		echo "======================================="
		echo -e "ClawdBot > MoltBot > OpenClaw 绠＄悊"
		echo -e "$install_status $running_status $update_message"
		echo "======================================="
		echo "1.  瀹夎"
		echo "2.  鍚姩"
		echo "3.  鍋滄"
		echo "--------------------"
		echo "4.  鐘舵€佹棩蹇楁煡鐪?
		echo "5.  鎹㈡ā鍨?
		echo "6.  鍔犳柊妯″瀷API"
		echo "7.  TG杈撳叆杩炴帴鐮?
		echo "8.  瀹夎鎻掍欢锛堝锛氶涔︼級"
		echo "9.  瀹夎鎶€鑳斤紙skills锛?
		echo "10. 缂栬緫涓婚厤缃枃浠?
		echo "11. 閰嶇疆鍚戝"
		echo "12. 鍋ュ悍妫€娴嬩笌淇"
		echo "13. WebUI璁块棶涓庤缃?
		echo "--------------------"
		echo "14. 鏇存柊"
		echo "15. 鍗歌浇"
		echo "--------------------"
		echo "0. 杩斿洖涓婁竴绾ч€夊崟"
		echo "--------------------"
		printf "璇疯緭鍏ラ€夐」骞跺洖杞? "
	}


	start_gateway() {
		openclaw gateway stop
		openclaw gateway start
		sleep 3
	}


	install_node_and_tools() {
		if command -v dnf &>/dev/null; then
			curl -fsSL https://rpm.nodesource.com/setup_24.x | sudo bash -
			dnf update -y
			dnf group install -y "Development Tools" "Development Libraries"
			dnf install -y cmake libatomic nodejs
		fi

		if command -v apt &>/dev/null; then
			curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
			apt update -y
			apt install build-essential python3 libatomic1 nodejs -y
		fi
	}

	install_moltbot() {
		echo "寮€濮嬪畨瑁?OpenClaw..."
		send_stats "寮€濮嬪畨瑁?OpenClaw..."

		install_node_and_tools

		country=$(curl -s ipinfo.io/country)
		if [[ "$country" == "CN" || "$country" == "HK" ]]; then
			npm config set registry https://registry.npmmirror.com
		fi
		npm install -g openclaw@latest
		openclaw onboard --install-daemon
		start_gateway
		add_app_id
		break_end

	}


	start_bot() {
		echo "鍚姩 OpenClaw..."
		send_stats "鍚姩 OpenClaw..."
		start_gateway
		break_end
	}

	stop_bot() {
		echo "鍋滄 OpenClaw..."
		send_stats "鍋滄 OpenClaw..."
		tmux kill-session -t gateway > /dev/null 2>&1
		openclaw gateway stop
		break_end
	}

	view_logs() {
		echo "鏌ョ湅 OpenClaw 鐘舵€佹棩蹇?
		send_stats "鏌ョ湅 OpenClaw 鏃ュ織"
		openclaw status
		openclaw gateway status
		openclaw logs
		break_end
	}





	# 鏍稿績鍑芥暟锛氳幏鍙栧苟娣诲姞鎵€鏈夋ā鍨?
	add-all-models-from-provider() {
		local provider_name="$1"
		local base_url="$2"
		local api_key="$3"
		local config_file="${HOME}/.openclaw/openclaw.json"

		echo "馃攳 姝ｅ湪鑾峰彇 $provider_name 鐨勬墍鏈夊彲鐢ㄦā鍨?.."

		# 鑾峰彇妯″瀷鍒楄〃
		local models_json=$(curl -s -m 10 \
			-H "Authorization: Bearer $api_key" \
			"${base_url}/models")

		if [[ -z "$models_json" ]]; then
			echo "鉂?鏃犳硶鑾峰彇妯″瀷鍒楄〃"
			return 1
		fi

		# 鎻愬彇鎵€鏈夋ā鍨婭D
		local model_ids=$(echo "$models_json" | grep -oP '"id":\s*"\K[^"]+')

		if [[ -z "$model_ids" ]]; then
			echo "鉂?鏈壘鍒颁换浣曟ā鍨?
			return 1
		fi

		local model_count=$(echo "$model_ids" | wc -l)
		echo "鉁?鍙戠幇 $model_count 涓ā鍨?

		# 鏅鸿兘鎺ㄦ柇妯″瀷鍙傛暟
		local models_array="["
		local first=true

		while read -r model_id; do
			[[ $first == false ]] && models_array+=","
			first=false

			# 鏍规嵁妯″瀷鍚嶇О鎺ㄦ柇涓婁笅鏂囩獥鍙?
			local context_window=131072
			local max_tokens=8192
			local input_cost=0.14
			local output_cost=0.28

			case "$model_id" in
				*preview*|*thinking*|*opus*|*pro*)
					context_window=1048576  # 1M
					max_tokens=16384
					input_cost=0.30
					output_cost=0.60
					;;
				*gpt-5*|*codex*)
					context_window=131072   # 128K
					max_tokens=8192
					input_cost=0.20
					output_cost=0.40
					;;
				*flash*|*lite*|*haiku*)
					context_window=131072
					max_tokens=8192
					input_cost=0.07
					output_cost=0.14
					;;
			esac

			models_array+=$(cat <<EOF
{
	"id": "$model_id",
	"name": "$provider_name / $model_id",
	"input": ["text", "image"],
	"contextWindow": $context_window,
	"maxTokens": $max_tokens,
	"cost": {
		"input": $input_cost,
		"output": $output_cost,
		"cacheRead": 0,
		"cacheWrite": 0
	}
}
EOF
)
		done <<< "$model_ids"

		models_array+="]"

		# 澶囦唤閰嶇疆
		[[ -f "$config_file" ]] && cp "$config_file" "${config_file}.bak.$(date +%s)"

		# 浣跨敤jq娉ㄥ叆鎵€鏈夋ā鍨?
		jq --arg prov "$provider_name" \
		   --arg url "$base_url" \
		   --arg key "$api_key" \
		   --argjson models "$models_array" \
		'
		.models |= (
			(. // { mode: "merge", providers: {} })
			| .mode = "merge"
			| .providers[$prov] = {
				baseUrl: $url,
				apiKey: $key,
				api: "openai-completions",
				models: $models
			}
		)
		' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"

		if [[ $? -eq 0 ]]; then
			echo "鉁?鎴愬姛娣诲姞 $model_count 涓ā鍨嬪埌 $provider_name"
			echo "馃摝 妯″瀷寮曠敤鏍煎紡: $provider_name/<model-id>"
			return 0
		else
			echo "鉂?閰嶇疆娉ㄥ叆澶辫触"
			return 1
		fi
	}

	add-openclaw-provider-interactive() {
		send_stats "娣诲姞API"
		echo "=== 浜や簰寮忔坊鍔?OpenClaw Provider (鍏ㄩ噺妯″瀷) ==="

		# 1. Provider 鍚嶇О
		read -erp "璇疯緭鍏?Provider 鍚嶇О (濡? deepseek): " provider_name
		while [[ -z "$provider_name" ]]; do
			echo "鉂?Provider 鍚嶇О涓嶈兘涓虹┖"
			read -erp "璇疯緭鍏?Provider 鍚嶇О: " provider_name
		done

		# 2. Base URL
		read -erp "璇疯緭鍏?Base URL (濡? https://api.xxx.com/v1): " base_url
		while [[ -z "$base_url" ]]; do
			echo "鉂?Base URL 涓嶈兘涓虹┖"
			read -erp "璇疯緭鍏?Base URL: " base_url
		done
		base_url="${base_url%/}"

		# 3. API Key
		read -rsp "璇疯緭鍏?API Key (杈撳叆涓嶆樉绀?: " api_key
		echo
		while [[ -z "$api_key" ]]; do
			echo "鉂?API Key 涓嶈兘涓虹┖"
			read -rsp "璇疯緭鍏?API Key: " api_key
			echo
		done

		# 4. 鑾峰彇妯″瀷鍒楄〃
		echo "馃攳 姝ｅ湪鑾峰彇鍙敤妯″瀷鍒楄〃..."
		models_json=$(curl -s -m 10 \
			-H "Authorization: Bearer $api_key" \
			"${base_url}/models")

		if [[ -n "$models_json" ]]; then
			available_models=$(echo "$models_json" | grep -oP '"id":\s*"\K[^"]+' | sort)

			if [[ -n "$available_models" ]]; then
				model_count=$(echo "$available_models" | wc -l)
				echo "鉁?鍙戠幇 $model_count 涓彲鐢ㄦā鍨嬶細"
				echo "--------------------------------"
				# 鍏ㄩ儴鏄剧ず锛屽甫搴忓彿
				i=1
				declare -A model_map
				while read -r model; do
					echo "[$i] $model"
					model_map[$i]="$model"
					((i++))
				done <<< "$available_models"
				echo "--------------------------------"
			fi
		fi

		# 5. 閫夋嫨榛樿妯″瀷
		echo
		read -erp "璇疯緭鍏ラ粯璁?Model ID (鎴栧簭鍙凤紝鐣欑┖鍒欎娇鐢ㄧ涓€涓?: " input_model

		if [[ -z "$input_model" && -n "$available_models" ]]; then
			default_model=$(echo "$available_models" | head -1)
			echo "馃幆 浣跨敤绗竴涓ā鍨? $default_model"
		elif [[ -n "${model_map[$input_model]}" ]]; then
			default_model="${model_map[$input_model]}"
			echo "馃幆 宸查€夋嫨妯″瀷: $default_model"
		else
			default_model="$input_model"
		fi

		# 6. 纭淇℃伅
		echo
		echo "====== 纭淇℃伅 ======"
		echo "Provider    : $provider_name"
		echo "Base URL    : $base_url"
		echo "API Key     : ${api_key:0:8}****"
		echo "榛樿妯″瀷    : $default_model"
		echo "妯″瀷鎬绘暟    : $model_count"
		echo "======================"

		read -erp "纭娣诲姞鎵€鏈?$model_count 涓ā鍨嬶紵(y/N): " confirm
		if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
			echo "鉂?宸插彇娑?
			return 1
		fi

		install jq
		add-all-models-from-provider "$provider_name" "$base_url" "$api_key"

		if [[ $? -eq 0 ]]; then
			echo
			echo "馃攧 璁剧疆榛樿妯″瀷骞堕噸鍚綉鍏?.."
			openclaw models set "$provider_name/$default_model"
			start_gateway
			echo "鉁?瀹屾垚锛佹墍鏈?$model_count 涓ā鍨嬪凡鍔犺浇"
		fi

		break_end
	}



	change_model() {
		send_stats "鎹㈡ā鍨?

		while true; do
			clear
			echo "--- 妯″瀷绠＄悊 ---"
			echo "鎵€鏈夋ā鍨?"
			openclaw models list --all
			echo "----------------"
			echo "褰撳墠妯″瀷:"
			openclaw models list
			echo "----------------"
			read -e -p "璇疯緭鍏ヨ璁剧疆鐨勬ā鍨嬪悕绉?(渚嬪 openrouter/openai/gpt-4o)锛堣緭鍏?0 閫€鍑猴級锛?" model

			# 1. 妫€鏌ユ槸鍚﹁緭鍏?0 浠ラ€€鍑?
			if [ "$model" = "0" ]; then
				echo "鎿嶄綔宸插彇娑堬紝姝ｅ湪閫€鍑?.."
				break  # 璺冲嚭 while 寰幆

			fi

			# 2. 楠岃瘉杈撳叆鏄惁涓虹┖
			if [ -z "$model" ]; then
				echo "閿欒锛氭ā鍨嬪悕绉颁笉鑳戒负绌恒€傝閲嶈瘯銆?
				echo "" # 鎹㈣缇庡寲
				continue # 璺宠繃鏈寰幆锛岄噸鏂板紑濮?
			fi

			# 3. 鎵ц鍒囨崲閫昏緫
			echo "姝ｅ湪鍒囨崲妯″瀷涓? $model ..."
			openclaw models set "$model"

			break_end
		done

	}




	install_plugin() {

		send_stats "瀹夎鎻掍欢"
		while true; do
			clear
			echo "========================================"
			echo "            鎻掍欢绠＄悊 (瀹夎)            "
			echo "========================================"
			echo "褰撳墠宸插畨瑁呮彃浠?"
			openclaw plugins list
			echo "----------------------------------------"

			# 杈撳嚭鎺ㄨ崘鐨勫疄鐢ㄦ彃浠跺垪琛紝渚夸簬鐢ㄦ埛澶嶅埗
			echo "鎺ㄨ崘鐨勫疄鐢ㄦ彃浠讹紙鍙洿鎺ュ鍒跺悕绉拌緭鍏ワ級锛?
			echo "feishu                # 椋炰功/Lark 闆嗘垚 (褰撳墠宸插姞杞?鉁?"
			echo "telegram              # Telegram 鏈哄櫒浜洪泦鎴?(褰撳墠宸插姞杞?鉁?"
			echo "memory-core           # 鏍稿績璁板繂澧炲己锛氬熀浜庢枃浠剁殑涓婁笅鏂囨悳绱?(褰撳墠宸插姞杞?鉁?"
			echo "@openclaw/slack       # Slack 棰戦亾涓?DMs 娣卞害杩炴帴"
			echo "@openclaw/bluebubbles # iMessage 妗ユ帴 (macOS 鐢ㄦ埛棣栭€?"
			echo "@openclaw/msteams     # Microsoft Teams 浼佷笟閫氳闆嗘垚"
			echo "@openclaw/voice-call  # 璇煶閫氳瘽鎻掍欢 (鍩轰簬 Twilio 绛夊悗绔?"
			echo "@openclaw/discord     # Discord 棰戦亾鑷姩鍖栫鐞?
			echo "@openclaw/nostr       # Nostr 鍗忚锛氶殣绉佸畨鍏ㄥ姞瀵嗚亰澶?
			echo "lobster               # 瀹℃壒宸ヤ綔娴侊細甯︽湁浜哄伐骞查鐨勮嚜鍔ㄤ换鍔?
			echo "memory-lancedb        # 闀挎湡璁板繂澧炲己锛氬熀浜庡悜閲忔暟鎹簱鐨勭簿鍑嗗彫鍥?
			echo "copilot-proxy         # GitHub Copilot 浠ｇ悊鎺ュ叆澧炲己"
			echo "----------------------------------------"

			# 鎻愮ず鐢ㄦ埛杈撳叆鎻掍欢鍚嶇О
			read -e -p "璇疯緭鍏ヨ瀹夎鐨勬彃浠跺悕绉帮紙杈撳叆 0 閫€鍑猴級锛?" plugin_name

			# 1. 妫€鏌ユ槸鍚﹁緭鍏?0 浠ラ€€鍑?
			if [ "$plugin_name" = "0" ]; then
				echo "鎿嶄綔宸插彇娑堬紝閫€鍑烘彃浠跺畨瑁呫€?
				break
			fi

			# 2. 楠岃瘉杈撳叆鏄惁涓虹┖
			if [ -z "$plugin_name" ]; then
				echo "閿欒锛氭彃浠跺悕绉颁笉鑳戒负绌猴紝璇烽噸鏂拌緭鍏ャ€?
				echo ""
				continue
			fi

			# 1. 褰诲簳娓呯悊涔嬪墠澶辫触鐨勬畫鐣欙紙鐢ㄦ埛鐩綍锛?
			rm -rf "/root/.openclaw/extensions/$plugin_name"

			# 2. 妫€鏌ョ郴缁熸槸鍚﹀凡缁忛瑁咃紙闃叉 duplicate id 鍐茬獊锛?
			if [ -d "/usr/lib/node_modules/openclaw/extensions/$plugin_name" ]; then
				echo "馃挕 妫€娴嬪埌绯荤粺鐩綍宸插瓨鍦ㄨ鎻掍欢锛屾鍦ㄧ洿鎺ユ縺娲?.."
				openclaw plugins enable "$plugin_name"
			else
				echo "馃摜 姝ｅ湪閫氳繃瀹樻柟娓犻亾涓嬭浇瀹夎鎻掍欢..."
				# 浣跨敤 openclaw 鑷繁鐨?install 鍛戒护锛屽畠浼氳嚜鍔ㄥ鐞?package.json 鐨勮鑼冩鏌?
				openclaw plugins install "$plugin_name"

				# 3. 濡傛灉 openclaw install 鎶ラ敊锛屽啀灏濊瘯浣滀负鏅€?npm 鍖呭畨瑁咃紙鏈€鍚庣殑澶囬€夛級
				if [ $? -ne 0 ]; then
					echo "鈿狅笍 瀹樻柟瀹夎澶辫触锛屽皾璇曢€氳繃 npm 鍏ㄥ眬寮哄埗瀹夎..."
					npm install -g "$plugin_name" --unsafe-perm
				fi

				# 4. 鏈€鍚庣粺涓€鎵ц鍚敤
				openclaw plugins enable "$plugin_name"
			fi

			start_gateway
			break_end
		done
	}

	install_plugin() {
		send_stats "瀹夎鎻掍欢"
		while true; do
			clear
			echo "========================================"
			echo "            鎻掍欢绠＄悊 (瀹夎)            "
			echo "========================================"
			echo "褰撳墠鎻掍欢鍒楄〃:"
			openclaw plugins list
			echo "--------------------------------------------------------"
			echo "鎺ㄨ崘鐨勫父鐢ㄦ彃浠?ID (鐩存帴澶嶅埗鎷彿鍐呯殑 ID 鍗冲彲):"
			echo "--------------------------------------------------------"
			echo "馃摫 閫氳娓犻亾:"
			echo "  - [feishu]       	# 椋炰功/Lark 闆嗘垚"
			echo "  - [telegram]     	# Telegram 鏈哄櫒浜?
			echo "  - [slack]        	# Slack 浼佷笟閫氳"
			echo "  - [msteams]      	# Microsoft Teams"
			echo "  - [discord]      	# Discord 绀惧尯绠＄悊"
			echo "  - [whatsapp]     	# WhatsApp 鑷姩鍖?
			echo ""
			echo "馃 璁板繂涓?AI:"
			echo "  - [memory-core]  	# 鍩虹璁板繂 (鏂囦欢妫€绱?"
			echo "  - [memory-lancedb]	# 澧炲己璁板繂 (鍚戦噺鏁版嵁搴?"
			echo "  - [copilot-proxy]	# Copilot 鎺ュ彛杞彂"
			echo ""
			echo "鈿欙笍 鍔熻兘鎵╁睍:"
			echo "  - [lobster]      	# 瀹℃壒娴?(甯︿汉宸ョ‘璁?"
			echo "  - [voice-call]   	# 璇煶閫氳瘽鑳藉姏"
			echo "  - [nostr]        	# 鍔犲瘑闅愮鑱婂ぉ"
			echo "--------------------------------------------------------"

			read -e -p "璇疯緭鍏ユ彃浠?ID锛堣緭鍏?0 閫€鍑猴級锛?" raw_input

			[ "$raw_input" = "0" ] && break
			[ -z "$raw_input" ] && continue

			# 1. 鑷姩澶勭悊锛氬鏋滅敤鎴疯緭鍏ュ甫 @openclaw/锛屾彁鍙栫函 ID 鏂逛究璺緞妫€鏌?
			local plugin_id=$(echo "$raw_input" | sed 's|^@openclaw/||')
			local plugin_full="$raw_input"

			echo "馃攳 姝ｅ湪妫€鏌ユ彃浠剁姸鎬?.."

			# 2. 妫€鏌ユ槸鍚﹀凡缁忓湪 list 涓笖涓?disabled (鏈€甯歌鐨勬儏鍐?
			if echo "$plugin_list" | grep -qw "$plugin_id" && echo "$plugin_list" | grep "$plugin_id" | grep -q "disabled"; then
				echo "馃挕 鎻掍欢 [$plugin_id] 宸查瑁咃紝姝ｅ湪婵€娲?.."
				openclaw plugins enable "$plugin_id" && echo "鉁?婵€娲绘垚鍔? || echo "鉂?婵€娲诲け璐?

			# 3. 妫€鏌ョ郴缁熺墿鐞嗙洰褰曟槸鍚﹀瓨鍦?
			elif [ -d "/usr/lib/node_modules/openclaw/extensions/$plugin_id" ]; then
				echo "馃挕 鍙戠幇绯荤粺鍐呯疆鐩綍瀛樺湪璇ユ彃浠讹紝灏濊瘯鐩存帴鍚敤..."
				openclaw plugins enable "$plugin_id"

			else
				# 4. 杩滅▼瀹夎閫昏緫
				echo "馃摜 鏈湴鏈彂鐜帮紝灏濊瘯涓嬭浇瀹夎..."

				# 娓呯悊鏃х殑澶辫触娈嬬暀
				rm -rf "/root/.openclaw/extensions/$plugin_id"

				# 鎵ц瀹夎锛屽苟鎹曡幏缁撴灉
				if openclaw plugins install "$plugin_full"; then
					echo "鉁?涓嬭浇鎴愬姛锛屾鍦ㄥ惎鐢?.."
					openclaw plugins enable "$plugin_id"
				else
					echo "鈿狅笍 瀹樻柟娓犻亾涓嬭浇澶辫触锛屽皾璇曞閫夋柟妗?.."
					# 澶囬€?npm 瀹夎
					if npm install -g "$plugin_full" --unsafe-perm; then
						echo "鉁?npm 瀹夎鎴愬姛锛屽皾璇曞惎鐢?.."
						openclaw plugins enable "$plugin_id"
					else
						echo "鉂?涓ラ噸閿欒锛氭棤娉曡幏鍙栬鎻掍欢銆傝妫€鏌?ID 鏄惁姝ｇ‘鎴栫綉缁滄槸鍚﹀彲鐢ㄣ€?
						# 鍏抽敭锛氳繖閲岀洿鎺?return 鎴?continue锛屼笉璧颁笅闈㈢殑 start_gateway锛岄槻姝㈠啓姝婚厤缃?
						break_end
						continue
					fi
				fi
			fi

			echo "馃攧 姝ｅ湪閲嶅惎 OpenClaw 鏈嶅姟浠ュ姞杞芥柊鎻掍欢..."
			start_gateway
			break_end
		done
	}







	install_skill() {
		send_stats "瀹夎鎶€鑳?
		while true; do
			clear
			echo "========================================"
			echo "            鎶€鑳界鐞?(瀹夎)            "
			echo "========================================"
			echo "褰撳墠宸插畨瑁呮妧鑳?"
			openclaw skills list
			echo "----------------------------------------"

			# 杈撳嚭鎺ㄨ崘鐨勫疄鐢ㄦ妧鑳藉垪琛?
			echo "鎺ㄨ崘鐨勫疄鐢ㄦ妧鑳斤紙鍙洿鎺ュ鍒跺悕绉拌緭鍏ワ級锛?
			echo "github             # 绠＄悊 GitHub Issues/PR/CI (gh CLI)"
			echo "notion             # 鎿嶄綔 Notion 椤甸潰銆佹暟鎹簱鍜屽潡"
			echo "apple-notes        # macOS 鍘熺敓绗旇绠＄悊 (鍒涘缓/缂栬緫/鎼滅储)"
			echo "apple-reminders    # macOS 鎻愰啋浜嬮」绠＄悊 (寰呭姙娓呭崟)"
			echo "1password          # 鑷姩鍖栬鍙栧拰娉ㄥ叆 1Password 瀵嗛挜"
			echo "gog                # Google Workspace (Gmail/浜戠洏/鏂囨。) 鍏ㄨ兘鍔╂墜"
			echo "things-mac         # 娣卞害鏁村悎 Things 3 浠诲姟绠＄悊"
			echo "bluebubbles        # 閫氳繃 BlueBubbles 瀹岀編鏀跺彂 iMessage"
			echo "himalaya           # 缁堢閭欢绠＄悊 (IMAP/SMTP 寮哄姏宸ュ叿)"
			echo "summarize          # 缃戦〉/鎾/YouTube 瑙嗛鍐呭涓€閿€荤粨"
			echo "openhue            # 鎺у埗 Philips Hue 鏅鸿兘鐏厜鍦烘櫙"
			echo "video-frames       # 瑙嗛鎶藉抚涓庣煭鐗囧壀杈?(ffmpeg 椹卞姩)"
			echo "openai-whisper     # 鏈湴闊抽杞枃瀛?(绂荤嚎闅愮淇濇姢)"
			echo "coding-agent       # 鑷姩杩愯 Claude Code/Codex 绛夌紪绋嬪姪鎵?
			echo "----------------------------------------"

			# 鎻愮ず鐢ㄦ埛杈撳叆鎶€鑳藉悕绉?
			read -e -p "璇疯緭鍏ヨ瀹夎鐨勬妧鑳藉悕绉帮紙杈撳叆 0 閫€鍑猴級锛?" skill_name

			# 1. 妫€鏌ユ槸鍚﹁緭鍏?0 浠ラ€€鍑?
			if [ "$skill_name" = "0" ]; then
				echo "鎿嶄綔宸插彇娑堬紝閫€鍑烘妧鑳藉畨瑁呫€?
				break
			fi

			# 2. 楠岃瘉杈撳叆鏄惁涓虹┖
			if [ -z "$skill_name" ]; then
				echo "閿欒锛氭妧鑳藉悕绉颁笉鑳戒负绌恒€傝閲嶈瘯銆?
				echo ""
				continue
			fi

			# 3. 鎵ц瀹夎鍛戒护
			echo "姝ｅ湪瀹夎鎶€鑳斤細$skill_name ..."
			npx clawhub install "$skill_name"

			# 鑾峰彇涓婁竴鏉″懡浠ょ殑閫€鍑虹姸鎬?
			if [ $? -eq 0 ]; then
				echo "鉁?鎶€鑳?$skill_name 瀹夎鎴愬姛銆?
				# 鎵ц閲嶅惎/鍚姩鏈嶅姟閫昏緫
				start_gateway
			else
				echo "鉂?瀹夎澶辫触銆傝妫€鏌ユ妧鑳藉悕绉版槸鍚︽纭紝鎴栧弬鑰冩枃妗ｆ帓鏌ャ€?
			fi

			break_end
		done

	}



	change_tg_bot_code() {
		send_stats "鏈哄櫒浜哄鎺?
		read -e -p "璇疯緭鍏G鏈哄櫒浜烘敹鍒扮殑杩炴帴鐮?(渚嬪 Pairing code: NYA99R2F)锛堣緭鍏?0 閫€鍑猴級锛?" code

		# 妫€鏌ユ槸鍚﹁緭鍏?0 浠ラ€€鍑?
		if [ "$code" = "0" ]; then
			echo "鎿嶄綔宸插彇娑堛€?
			return 0  # 姝ｅ父閫€鍑哄嚱鏁?
		fi

		# 楠岃瘉杈撳叆鏄惁涓虹┖
		if [ -z "$code" ]; then
			echo "閿欒锛氳繛鎺ョ爜涓嶈兘涓虹┖銆傝閲嶈瘯銆?
			return 1
		fi

		openclaw pairing approve telegram $code
		break_end
	}


	update_moltbot() {
		echo "鏇存柊 OpenClaw..."
		send_stats "鏇存柊 OpenClaw..."
		install_node_and_tools
		npm install -g openclaw@latest
		start_gateway
		hash -r
		add_app_id
		echo "鏇存柊瀹屾垚"
		break_end
	}


	uninstall_moltbot() {
		echo "鍗歌浇 OpenClaw..."
		send_stats "鍗歌浇 OpenClaw..."
		openclaw uninstall
		npm uninstall -g openclaw
		crontab -l 2>/dev/null | grep -v "s gateway" | crontab -
		hash -r
		sed -i "/\b${app_id}\b/d" /home/docker/appno.txt
		echo "鍗歌浇瀹屾垚"
		break_end
	}

	nano_openclaw_json() {
		send_stats "缂栬緫 OpenClaw 閰嶇疆鏂囦欢"
		install nano
		nano ~/.openclaw/openclaw.json
		start_gateway
	}






	openclaw_find_webui_domain() {
		local conf domain_list

		domain_list=$(
			grep -R "18789" /home/web/conf.d/*.conf 2>/dev/null \
			| awk -F: '{print $1}' \
			| sort -u \
			| while read conf; do
				basename "$conf" .conf
			done
		)

		if [ -n "$domain_list" ]; then
			echo "$domain_list"
		fi
	}



	openclaw_show_webui_addr() {
		local local_ip token domains

		echo "=================================="
		echo "OpenClaw WebUI 璁块棶鍦板潃"
		local_ip="127.0.0.1"

		token=$(
			openclaw dashboard 2>/dev/null \
			| sed -n 's/.*:18789\/#token=\([a-f0-9]\+\).*/\1/p' \
			| head -n 1
		)
		echo
		echo "鏈満鍦板潃锛?
		echo "http://${local_ip}:18789/#token=${token}"

		domains=$(openclaw_find_webui_domain)
		if [ -n "$domains" ]; then
			echo "鍩熷悕鍦板潃锛?
			echo "$domains" | while read d; do
				echo "https://${d}/#token=${token}"
			done
		fi

		echo "=================================="
	}



	# 娣诲姞鍩熷悕锛堣皟鐢ㄤ綘缁欑殑鍑芥暟锛?
	openclaw_domain_webui() {
		add_yuming
		ldnmp_Proxy ${yuming} 127.0.0.1 18789

		token=$(
			openclaw dashboard 2>/dev/null \
			| sed -n 's/.*:18789\/#token=\([a-f0-9]\+\).*/\1/p' \
			| head -n 1
		)

		clear
		echo "璁块棶鍦板潃:"
		echo "https://${yuming}/#token=$token"
		echo "鍏堣闂甎RL瑙﹀彂璁惧ID锛岀劧鍚庡洖杞︿笅涓€姝ヨ繘琛岄厤瀵广€?
		read
		echo -e "${gl_kjlan}姝ｅ湪鍔犺浇璁惧鍒楄〃鈥︹€?{gl_bai}"
		openclaw devices list

		read -e -p "璇疯緭鍏?Request_Key: " Request_Key

		[ -z "$Request_Key" ] && {
			echo "Request_Key 涓嶈兘涓虹┖"
			return 1
		}

		openclaw devices approve "$Request_Key"

	}

	# 鍒犻櫎鍩熷悕
	openclaw_remove_domain() {
		echo "鍩熷悕鏍煎紡 example.com 涓嶅甫https://"
		web_del
	}

	# 涓昏彍鍗?
	openclaw_webui_menu() {

		send_stats "WebUI璁块棶涓庤缃?
		while true; do
			clear
			openclaw_show_webui_addr
			echo
			echo "1. 娣诲姞鍩熷悕璁块棶"
			echo "2. 鍒犻櫎鍩熷悕璁块棶"
			echo "0. 閫€鍑?
			echo
			read -e -p "璇烽€夋嫨: " choice

			case "$choice" in
				1)
					openclaw_domain_webui
					echo
					read -p "鎸夊洖杞﹁繑鍥炶彍鍗?.."
					;;
				2)
					openclaw_remove_domain
					read -p "鎸夊洖杞﹁繑鍥炶彍鍗?.."
					;;
				0)
					break
					;;
				*)
					echo "鏃犳晥閫夐」"
					sleep 1
					;;
			esac
		done
	}



	# 涓诲惊鐜?
	while true; do
		show_menu
		read choice
		case $choice in
			1) install_moltbot ;;
			2) start_bot ;;
			3) stop_bot ;;
			4) view_logs ;;
			5) change_model ;;
			6) add-openclaw-provider-interactive ;;
			7) change_tg_bot_code ;;
			8) install_plugin ;;
			9) install_skill ;;
			10) nano_openclaw_json ;;
			11) send_stats "鍒濆鍖栭厤缃悜瀵?
				openclaw onboard --install-daemon
				break_end
				;;
			12) send_stats "鍋ュ悍妫€娴嬩笌淇"
				openclaw doctor --fix
				break_end
			 	;;
			13) openclaw_webui_menu ;;
			14) update_moltbot ;;
			15) uninstall_moltbot ;;
			*) break ;;
		esac
	done

}




linux_panel() {

local sub_choice="$1"

clear
cd ~
install git
echo -e "${gl_kjlan}姝ｅ湪鏇存柊搴旂敤鍒楄〃璇风◢绛夆€︹€?{gl_bai}"
if [ ! -d apps/.git ]; then
	timeout 10s git clone ${gh_proxy}github.com/xiaowoniu928/apps.git
else
	cd apps
	# git pull origin main > /dev/null 2>&1
	timeout 10s git pull ${gh_proxy}github.com/xiaowoniu928/apps.git main > /dev/null 2>&1
fi

while true; do

	if [ -z "$sub_choice" ]; then
	  clear
	  echo -e "搴旂敤甯傚満"
	  echo -e "${gl_kjlan}-------------------------"

	  local app_numbers=$([ -f /home/docker/appno.txt ] && cat /home/docker/appno.txt || echo "")

	  # 鐢ㄥ惊鐜缃鑹?
	  for i in {1..150}; do
		  if echo "$app_numbers" | grep -q "^$i$"; then
			  declare "color$i=${gl_lv}"
		  else
			  declare "color$i=${gl_bai}"
		  fi
	  done

	  echo -e "${gl_kjlan}1.   ${color1}瀹濆闈㈡澘瀹樻柟鐗?                     ${gl_kjlan}2.   ${color2}aaPanel瀹濆鍥介檯鐗?
	  echo -e "${gl_kjlan}3.   ${color3}1Panel鏂颁竴浠ｇ鐞嗛潰鏉?               ${gl_kjlan}4.   ${color4}NginxProxyManager鍙鍖栭潰鏉?
	  echo -e "${gl_kjlan}5.   ${color5}OpenList澶氬瓨鍌ㄦ枃浠跺垪琛ㄧ▼搴?         ${gl_kjlan}6.   ${color6}Ubuntu杩滅▼妗岄潰缃戦〉鐗?
	  echo -e "${gl_kjlan}7.   ${color7}鍝悞鎺㈤拡VPS鐩戞帶闈㈡澘                 ${gl_kjlan}8.   ${color8}QB绂荤嚎BT纾佸姏涓嬭浇闈㈡澘"
	  echo -e "${gl_kjlan}9.   ${color9}Poste.io閭欢鏈嶅姟鍣ㄧ▼搴?             ${gl_kjlan}10.  ${color10}RocketChat澶氫汉鍦ㄧ嚎鑱婂ぉ绯荤粺"
	  echo -e "${gl_kjlan}-------------------------"
	  echo -e "${gl_kjlan}11.  ${color11}绂呴亾椤圭洰绠＄悊杞欢                    ${gl_kjlan}12.  ${color12}闈掗緳闈㈡澘瀹氭椂浠诲姟绠＄悊骞冲彴"
	  echo -e "${gl_kjlan}13.  ${color13}Cloudreve缃戠洏 ${gl_huang}鈽?{gl_bai}                     ${gl_kjlan}14.  ${color14}绠€鍗曞浘搴婂浘鐗囩鐞嗙▼搴?
	  echo -e "${gl_kjlan}15.  ${color15}emby澶氬獟浣撶鐞嗙郴缁?                 ${gl_kjlan}16.  ${color16}Speedtest娴嬮€熼潰鏉?
	  echo -e "${gl_kjlan}17.  ${color17}AdGuardHome鍘诲箍鍛婅蒋浠?              ${gl_kjlan}18.  ${color18}onlyoffice鍦ㄧ嚎鍔炲叕OFFICE"
	  echo -e "${gl_kjlan}19.  ${color19}闆锋睜WAF闃茬伀澧欓潰鏉?                  ${gl_kjlan}20.  ${color20}portainer瀹瑰櫒绠＄悊闈㈡澘"
	  echo -e "${gl_kjlan}-------------------------"
	  echo -e "${gl_kjlan}21.  ${color21}VScode缃戦〉鐗?                       ${gl_kjlan}22.  ${color22}UptimeKuma鐩戞帶宸ュ叿"
	  echo -e "${gl_kjlan}23.  ${color23}Memos缃戦〉澶囧繕褰?                    ${gl_kjlan}24.  ${color24}Webtop杩滅▼妗岄潰缃戦〉鐗?${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}25.  ${color25}Nextcloud缃戠洏                       ${gl_kjlan}26.  ${color26}QD-Today瀹氭椂浠诲姟绠＄悊妗嗘灦"
	  echo -e "${gl_kjlan}27.  ${color27}Dockge瀹瑰櫒鍫嗘爤绠＄悊闈㈡澘              ${gl_kjlan}28.  ${color28}LibreSpeed娴嬮€熷伐鍏?
	  echo -e "${gl_kjlan}29.  ${color29}searxng鑱氬悎鎼滅储绔?${gl_huang}鈽?{gl_bai}                 ${gl_kjlan}30.  ${color30}PhotoPrism绉佹湁鐩稿唽绯荤粺"
	  echo -e "${gl_kjlan}-------------------------"
	  echo -e "${gl_kjlan}31.  ${color31}StirlingPDF宸ュ叿澶у叏                 ${gl_kjlan}32.  ${color32}drawio鍏嶈垂鐨勫湪绾垮浘琛ㄨ蒋浠?${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}33.  ${color33}Sun-Panel瀵艰埅闈㈡澘                   ${gl_kjlan}34.  ${color34}Pingvin-Share鏂囦欢鍒嗕韩骞冲彴"
	  echo -e "${gl_kjlan}35.  ${color35}鏋佺畝鏈嬪弸鍦?                         ${gl_kjlan}36.  ${color36}LobeChatAI鑱婂ぉ鑱氬悎缃戠珯"
	  echo -e "${gl_kjlan}37.  ${color37}MyIP宸ュ叿绠?${gl_huang}鈽?{gl_bai}                        ${gl_kjlan}38.  ${color38}灏忛泤alist鍏ㄥ妗?
	  echo -e "${gl_kjlan}39.  ${color39}Bililive鐩存挱褰曞埗宸ュ叿                ${gl_kjlan}40.  ${color40}webssh缃戦〉鐗圫SH杩炴帴宸ュ叿"
	  echo -e "${gl_kjlan}-------------------------"
	  echo -e "${gl_kjlan}41.  ${color41}鑰楀瓙绠＄悊闈㈡澘                	 ${gl_kjlan}42.  ${color42}Nexterm杩滅▼杩炴帴宸ュ叿"
	  echo -e "${gl_kjlan}43.  ${color43}RustDesk杩滅▼妗岄潰(鏈嶅姟绔? ${gl_huang}鈽?{gl_bai}          ${gl_kjlan}44.  ${color44}RustDesk杩滅▼妗岄潰(涓户绔? ${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}45.  ${color45}Docker鍔犻€熺珯            		 ${gl_kjlan}46.  ${color46}GitHub鍔犻€熺珯 ${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}47.  ${color47}鏅綏绫充慨鏂洃鎺?		 ${gl_kjlan}48.  ${color48}鏅綏绫充慨鏂?涓绘満鐩戞帶)"
	  echo -e "${gl_kjlan}49.  ${color49}鏅綏绫充慨鏂?瀹瑰櫒鐩戞帶)		 ${gl_kjlan}50.  ${color50}琛ヨ揣鐩戞帶宸ュ叿"
	  echo -e "${gl_kjlan}-------------------------"
	  echo -e "${gl_kjlan}51.  ${color51}PVE寮€灏忛浮闈㈡澘			 ${gl_kjlan}52.  ${color52}DPanel瀹瑰櫒绠＄悊闈㈡澘"
	  echo -e "${gl_kjlan}53.  ${color53}llama3鑱婂ぉAI澶фā鍨?                 ${gl_kjlan}54.  ${color54}AMH涓绘満寤虹珯绠＄悊闈㈡澘"
	  echo -e "${gl_kjlan}55.  ${color55}FRP鍐呯綉绌块€?鏈嶅姟绔? ${gl_huang}鈽?{gl_bai}	         ${gl_kjlan}56.  ${color56}FRP鍐呯綉绌块€?瀹㈡埛绔? ${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}57.  ${color57}Deepseek鑱婂ぉAI澶фā鍨?               ${gl_kjlan}58.  ${color58}Dify澶фā鍨嬬煡璇嗗簱 ${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}59.  ${color59}NewAPI澶фā鍨嬭祫浜х鐞?               ${gl_kjlan}60.  ${color60}JumpServer寮€婧愬牎鍨掓満"
	  echo -e "${gl_kjlan}-------------------------"
	  echo -e "${gl_kjlan}61.  ${color61}鍦ㄧ嚎缈昏瘧鏈嶅姟鍣?		 ${gl_kjlan}62.  ${color62}RAGFlow澶фā鍨嬬煡璇嗗簱"
	  echo -e "${gl_kjlan}63.  ${color63}OpenWebUI鑷墭绠I骞冲彴 ${gl_huang}鈽?{gl_bai}             ${gl_kjlan}64.  ${color64}it-tools宸ュ叿绠?
	  echo -e "${gl_kjlan}65.  ${color65}n8n鑷姩鍖栧伐浣滄祦骞冲彴 ${gl_huang}鈽?{gl_bai}               ${gl_kjlan}66.  ${color66}yt-dlp瑙嗛涓嬭浇宸ュ叿"
	  echo -e "${gl_kjlan}67.  ${color67}ddns-go鍔ㄦ€丏NS绠＄悊宸ュ叿 ${gl_huang}鈽?{gl_bai}            ${gl_kjlan}68.  ${color68}AllinSSL璇佷功绠＄悊骞冲彴"
	  echo -e "${gl_kjlan}69.  ${color69}SFTPGo鏂囦欢浼犺緭宸ュ叿                  ${gl_kjlan}70.  ${color70}AstrBot鑱婂ぉ鏈哄櫒浜烘鏋?
	  echo -e "${gl_kjlan}-------------------------"
	  echo -e "${gl_kjlan}71.  ${color71}Navidrome绉佹湁闊充箰鏈嶅姟鍣?            ${gl_kjlan}72.  ${color72}bitwarden瀵嗙爜绠＄悊鍣?${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}73.  ${color73}LibreTV绉佹湁褰辫                     ${gl_kjlan}74.  ${color74}MoonTV绉佹湁褰辫"
	  echo -e "${gl_kjlan}75.  ${color75}Melody闊充箰绮剧伒                      ${gl_kjlan}76.  ${color76}鍦ㄧ嚎DOS鑰佹父鎴?
	  echo -e "${gl_kjlan}77.  ${color77}杩呴浄绂荤嚎涓嬭浇宸ュ叿                    ${gl_kjlan}78.  ${color78}PandaWiki鏅鸿兘鏂囨。绠＄悊绯荤粺"
	  echo -e "${gl_kjlan}79.  ${color79}Beszel鏈嶅姟鍣ㄧ洃鎺?                   ${gl_kjlan}80.  ${color80}linkwarden涔︾绠＄悊"
	  echo -e "${gl_kjlan}-------------------------"
	  echo -e "${gl_kjlan}81.  ${color81}JitsiMeet瑙嗛浼氳                   ${gl_kjlan}82.  ${color82}gpt-load楂樻€ц兘AI閫忔槑浠ｇ悊"
	  echo -e "${gl_kjlan}83.  ${color83}komari鏈嶅姟鍣ㄧ洃鎺у伐鍏?               ${gl_kjlan}84.  ${color84}Wallos涓汉璐㈠姟绠＄悊宸ュ叿"
	  echo -e "${gl_kjlan}85.  ${color85}immich鍥剧墖瑙嗛绠＄悊鍣?               ${gl_kjlan}86.  ${color86}jellyfin濯掍綋绠＄悊绯荤粺"
	  echo -e "${gl_kjlan}87.  ${color87}SyncTV涓€璧风湅鐗囩鍣?                 ${gl_kjlan}88.  ${color88}Owncast鑷墭绠＄洿鎾钩鍙?
	  echo -e "${gl_kjlan}89.  ${color89}FileCodeBox鏂囦欢蹇€?                ${gl_kjlan}90.  ${color90}matrix鍘讳腑蹇冨寲鑱婂ぉ鍗忚"
	  echo -e "${gl_kjlan}-------------------------"
	  echo -e "${gl_kjlan}91.  ${color91}gitea绉佹湁浠ｇ爜浠撳簱                   ${gl_kjlan}92.  ${color92}FileBrowser鏂囦欢绠＄悊鍣?
	  echo -e "${gl_kjlan}93.  ${color93}Dufs鏋佺畝闈欐€佹枃浠舵湇鍔″櫒              ${gl_kjlan}94.  ${color94}Gopeed楂橀€熶笅杞藉伐鍏?
	  echo -e "${gl_kjlan}95.  ${color95}paperless鏂囨。绠＄悊骞冲彴               ${gl_kjlan}96.  ${color96}2FAuth鑷墭绠′簩姝ラ獙璇佸櫒"
	  echo -e "${gl_kjlan}97.  ${color97}WireGuard缁勭綉(鏈嶅姟绔?               ${gl_kjlan}98.  ${color98}WireGuard缁勭綉(瀹㈡埛绔?"
	  echo -e "${gl_kjlan}99.  ${color99}DSM缇ゆ櫀铏氭嫙鏈?                      ${gl_kjlan}100. ${color100}Syncthing鐐瑰鐐规枃浠跺悓姝ュ伐鍏?
	  echo -e "${gl_kjlan}-------------------------"
	  echo -e "${gl_kjlan}101. ${color101}AI瑙嗛鐢熸垚宸ュ叿                      ${gl_kjlan}102. ${color102}VoceChat澶氫汉鍦ㄧ嚎鑱婂ぉ绯荤粺"
	  echo -e "${gl_kjlan}103. ${color103}Umami缃戠珯缁熻宸ュ叿                   ${gl_kjlan}104. ${color104}Stream鍥涘眰浠ｇ悊杞彂宸ュ叿"
	  echo -e "${gl_kjlan}105. ${color105}鎬濇簮绗旇                            ${gl_kjlan}106. ${color106}Drawnix寮€婧愮櫧鏉垮伐鍏?
	  echo -e "${gl_kjlan}107. ${color107}PanSou缃戠洏鎼滅储                      ${gl_kjlan}108. ${color108}LangBot鑱婂ぉ鏈哄櫒浜?
	  echo -e "${gl_kjlan}109. ${color109}ZFile鍦ㄧ嚎缃戠洏                       ${gl_kjlan}110. ${color110}Karakeep涔︾绠＄悊"
	  echo -e "${gl_kjlan}-------------------------"
	  echo -e "${gl_kjlan}111. ${color111}澶氭牸寮忔枃浠惰浆鎹㈠伐鍏?                 ${gl_kjlan}112. ${color112}Lucky澶у唴缃戠┛閫忓伐鍏?
	  echo -e "${gl_kjlan}113. ${color113}Firefox娴忚鍣?                      ${gl_kjlan}114. ${color114}ClawdBot/Moltbot鏈哄櫒浜?{gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}-------------------------"
	  echo -e "${gl_kjlan}绗笁鏂瑰簲鐢ㄥ垪琛?
  	  echo -e "${gl_kjlan}鎯宠璁╀綘鐨勫簲鐢ㄥ嚭鐜板湪杩欓噷锛熸煡鐪嬪紑鍙戣€呮寚鍗? ${gl_huang}https://dev.kejilion.sh/${gl_bai}"

	  for f in "$HOME"/apps/*.conf; do
		  [ -e "$f" ] || continue
		  local base_name=$(basename "$f" .conf)
		  # 鑾峰彇搴旂敤鎻忚堪
		  local app_text=$(grep "app_text=" "$f" | cut -d'=' -f2 | tr -d '"' | tr -d "'")

		  # 妫€鏌ュ畨瑁呯姸鎬?(鍖归厤 appno.txt 涓殑 ID)
		  # 杩欓噷鍋囪 appno.txt 涓褰曠殑鏄?base_name (鍗虫枃浠跺悕)
		  if echo "$app_numbers" | grep -q "^$base_name$"; then
			  # 濡傛灉宸插畨瑁咃細鏄剧ず base_name - 鎻忚堪 [宸插畨瑁匽 (缁胯壊)
			  echo -e "${gl_kjlan}$base_name${gl_bai} - ${gl_lv}$app_text [宸插畨瑁匽${gl_bai}"
		  else
			  # 濡傛灉鏈畨瑁咃細姝ｅ父鏄剧ず
			  echo -e "${gl_kjlan}$base_name${gl_bai} - $app_text"
		  fi
	  done



	  echo -e "${gl_kjlan}-------------------------"
	  echo -e "${gl_kjlan}b.   ${gl_bai}澶囦唤鍏ㄩ儴搴旂敤鏁版嵁                    ${gl_kjlan}r.   ${gl_bai}杩樺師鍏ㄩ儴搴旂敤鏁版嵁"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}0.   ${gl_bai}杩斿洖涓昏彍鍗?
	  echo -e "${gl_kjlan}------------------------${gl_bai}"
	  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice
	fi

	case $sub_choice in
	  1|bt|baota)
		local app_id="1"
		local lujing="[ -d "/www/server/panel" ]"
		local panelname="瀹濆闈㈡澘"
		local panelurl="https://www.bt.cn/new/index.html"

		panel_app_install() {
			if [ -f /usr/bin/curl ];then curl -sSO https://download.bt.cn/install/install_panel.sh;else wget -O install_panel.sh https://download.bt.cn/install/install_panel.sh;fi;bash install_panel.sh ed8484bec
		}

		panel_app_manage() {
			bt
		}

		panel_app_uninstall() {
			curl -o bt-uninstall.sh http://download.bt.cn/install/bt-uninstall.sh > /dev/null 2>&1 && chmod +x bt-uninstall.sh && ./bt-uninstall.sh
			chmod +x bt-uninstall.sh
			./bt-uninstall.sh
		}

		install_panel



		  ;;
	  2|aapanel)


		local app_id="2"
		local lujing="[ -d "/www/server/panel" ]"
		local panelname="aapanel"
		local panelurl="https://www.aapanel.com/new/index.html"

		panel_app_install() {
			URL=https://www.aapanel.com/script/install_7.0_en.sh && if [ -f /usr/bin/curl ];then curl -ksSO "$URL" ;else wget --no-check-certificate -O install_7.0_en.sh "$URL";fi;bash install_7.0_en.sh aapanel
		}

		panel_app_manage() {
			bt
		}

		panel_app_uninstall() {
			curl -o bt-uninstall.sh http://download.bt.cn/install/bt-uninstall.sh > /dev/null 2>&1 && chmod +x bt-uninstall.sh && ./bt-uninstall.sh
			chmod +x bt-uninstall.sh
			./bt-uninstall.sh
		}

		install_panel

		  ;;
	  3|1p|1panel)

		local app_id="3"
		local lujing="command -v 1pctl"
		local panelname="1Panel"
		local panelurl="https://1panel.cn/"

		panel_app_install() {
			install bash
			bash -c "$(curl -sSL https://resource.fit2cloud.com/1panel/package/v2/quick_start.sh)"
		}

		panel_app_manage() {
			1pctl user-info
			1pctl update password
		}

		panel_app_uninstall() {
			1pctl uninstall
		}

		install_panel

		  ;;
	  4|npm)

		local app_id="4"
		local docker_name="npm"
		local docker_img="jc21/nginx-proxy-manager:latest"
		local docker_port=81

		docker_rum() {

			docker run -d \
			  --name=$docker_name \
			  -p ${docker_port}:81 \
			  -p 80:80 \
			  -p 443:443 \
			  -v /home/docker/npm/data:/data \
			  -v /home/docker/npm/letsencrypt:/etc/letsencrypt \
			  --restart=always \
			  $docker_img


		}

		local docker_describe="涓€涓狽ginx鍙嶅悜浠ｇ悊宸ュ叿闈㈡澘锛屼笉鏀寔娣诲姞鍩熷悕璁块棶銆?
		local docker_url="瀹樼綉浠嬬粛: https://nginxproxymanager.com/"
		local docker_use="echo \"鍒濆鐢ㄦ埛鍚? admin@example.com\""
		local docker_passwd="echo \"鍒濆瀵嗙爜: changeme\""
		local app_size="1"

		docker_app

		  ;;

	  5|openlist)

		local app_id="5"
		local docker_name="openlist"
		local docker_img="openlistteam/openlist:latest-aria2"
		local docker_port=5244

		docker_rum() {

			mkdir -p /home/docker/openlist
			chmod -R 777 /home/docker/openlist

			docker run -d \
				--restart=always \
				-v /home/docker/openlist:/opt/openlist/data \
				-p ${docker_port}:5244 \
				-e PUID=0 \
				-e PGID=0 \
				-e UMASK=022 \
				--name="openlist" \
				openlistteam/openlist:latest-aria2

		}


		local docker_describe="涓€涓敮鎸佸绉嶅瓨鍌紝鏀寔缃戦〉娴忚鍜?WebDAV 鐨勬枃浠跺垪琛ㄧ▼搴忥紝鐢?gin 鍜?Solidjs 椹卞姩"
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/OpenListTeam/OpenList"
		local docker_use="docker exec openlist ./openlist admin random"
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;

	  6|webtop-ubuntu)

		local app_id="6"
		local docker_name="webtop-ubuntu"
		local docker_img="lscr.io/linuxserver/webtop:ubuntu-kde"
		local docker_port=3006

		docker_rum() {

			read -e -p "璁剧疆鐧诲綍鐢ㄦ埛鍚? " admin
			read -e -p "璁剧疆鐧诲綍鐢ㄦ埛瀵嗙爜: " admin_password
			docker run -d \
			  --name=webtop-ubuntu \
			  --security-opt seccomp=unconfined \
			  -e PUID=1000 \
			  -e PGID=1000 \
			  -e TZ=Etc/UTC \
			  -e SUBFOLDER=/ \
			  -e TITLE=Webtop \
			  -e CUSTOM_USER=${admin} \
			  -e PASSWORD=${admin_password} \
			  -p ${docker_port}:3000 \
			  -v /home/docker/webtop/data:/config \
			  -v /var/run/docker.sock:/var/run/docker.sock \
			  --shm-size="1gb" \
			  --restart=always \
			  lscr.io/linuxserver/webtop:ubuntu-kde


		}


		local docker_describe="webtop鍩轰簬Ubuntu鐨勫鍣ㄣ€傝嫢IP鏃犳硶璁块棶锛岃娣诲姞鍩熷悕璁块棶銆?
		local docker_url="瀹樼綉浠嬬粛: https://docs.linuxserver.io/images/docker-webtop/"
		local docker_use=""
		local docker_passwd=""
		local app_size="2"
		docker_app


		  ;;
	  7|nezha)
		clear
		send_stats "鎼缓鍝悞"

		local app_id="7"
		local docker_name="nezha-dashboard"
		local docker_port=8008
		while true; do
			check_docker_app
			check_docker_image_update $docker_name
			clear
			echo -e "鍝悞鐩戞帶 $check_docker $update_status"
			echo "寮€婧愩€佽交閲忋€佹槗鐢ㄧ殑鏈嶅姟鍣ㄧ洃鎺т笌杩愮淮宸ュ叿"
			echo "瀹樼綉鎼缓鏂囨。: https://nezha.wiki/guide/dashboard.html"
			if docker ps -a --format '{{.Names}}' 2>/dev/null | grep -q "$docker_name"; then
				local docker_port=$(docker port $docker_name | awk -F'[:]' '/->/ {print $NF}' | uniq)
				check_docker_app_ip
			fi
			echo ""
			echo "------------------------"
			echo "1. 浣跨敤"
			echo "------------------------"
			echo "0. 杩斿洖涓婁竴绾ч€夊崟"
			echo "------------------------"
			read -e -p "杈撳叆浣犵殑閫夋嫨: " choice

			case $choice in
				1)
					check_disk_space 1
					install unzip jq
					install_docker
					curl -sL ${gh_proxy}raw.githubusercontent.com/nezhahq/scripts/refs/heads/main/install.sh -o nezha.sh && chmod +x nezha.sh && ./nezha.sh
					local docker_port=$(docker port $docker_name | awk -F'[:]' '/->/ {print $NF}' | uniq)
					check_docker_app_ip
					;;

				*)
					break
					;;

			esac
			break_end
		done
		  ;;

	  8|qb|QB)

		local app_id="8"
		local docker_name="qbittorrent"
		local docker_img="lscr.io/linuxserver/qbittorrent:latest"
		local docker_port=8081

		docker_rum() {

			docker run -d \
			  --name=qbittorrent \
			  -e PUID=1000 \
			  -e PGID=1000 \
			  -e TZ=Etc/UTC \
			  -e WEBUI_PORT=${docker_port} \
			  -e TORRENTING_PORT=56881 \
			  -p ${docker_port}:${docker_port} \
			  -p 56881:56881 \
			  -p 56881:56881/udp \
			  -v /home/docker/qbittorrent/config:/config \
			  -v /home/docker/qbittorrent/downloads:/downloads \
			  --restart=always \
			  lscr.io/linuxserver/qbittorrent:latest

		}

		local docker_describe="qbittorrent绂荤嚎BT纾佸姏涓嬭浇鏈嶅姟"
		local docker_url="瀹樼綉浠嬬粛: https://hub.docker.com/r/linuxserver/qbittorrent"
		local docker_use="sleep 3"
		local docker_passwd="docker logs qbittorrent"
		local app_size="1"
		docker_app

		  ;;

	  9|mail)
		send_stats "鎼缓閭眬"
		clear
		install telnet
		local app_id="9"
		local docker_name=鈥渕ailserver鈥?
		while true; do
			check_docker_app
			check_docker_image_update $docker_name

			clear
			echo -e "閭眬鏈嶅姟 $check_docker $update_status"
			echo "poste.io 鏄竴涓紑婧愮殑閭欢鏈嶅姟鍣ㄨВ鍐虫柟妗堬紝"
			echo "瑙嗛浠嬬粛: https://www.bilibili.com/video/BV1wv421C71t?t=0.1"

			echo ""
			echo "绔彛妫€娴?
			port=25
			timeout=3
			if echo "quit" | timeout $timeout telnet smtp.qq.com $port | grep 'Connected'; then
			  echo -e "${gl_lv}绔彛 $port 褰撳墠鍙敤${gl_bai}"
			else
			  echo -e "${gl_hong}绔彛 $port 褰撳墠涓嶅彲鐢?{gl_bai}"
			fi
			echo ""

			if docker ps -a --format '{{.Names}}' 2>/dev/null | grep -q "$docker_name"; then
				yuming=$(cat /home/docker/mail.txt)
				echo "璁块棶鍦板潃: "
				echo "https://$yuming"
			fi

			echo "------------------------"
			echo "1. 瀹夎           2. 鏇存柊           3. 鍗歌浇"
			echo "------------------------"
			echo "0. 杩斿洖涓婁竴绾ч€夊崟"
			echo "------------------------"
			read -e -p "杈撳叆浣犵殑閫夋嫨: " choice

			case $choice in
				1)
					setup_docker_dir
					check_disk_space 2 /home/docker
					read -e -p "璇疯缃偖绠卞煙鍚?渚嬪 mail.yuming.com : " yuming
					mkdir -p /home/docker
					echo "$yuming" > /home/docker/mail.txt
					echo "------------------------"
					ip_address
					echo "鍏堣В鏋愯繖浜汥NS璁板綍"
					echo "A           mail            $ipv4_address"
					echo "CNAME       imap            $yuming"
					echo "CNAME       pop             $yuming"
					echo "CNAME       smtp            $yuming"
					echo "MX          @               $yuming"
					echo "TXT         @               v=spf1 mx ~all"
					echo "TXT         ?               ?"
					echo ""
					echo "------------------------"
					echo "鎸変换鎰忛敭缁х画..."
					read -n 1 -s -r -p ""

					install jq
					install_docker

					docker run \
						--net=host \
						-e TZ=Europe/Prague \
						-v /home/docker/mail:/data \
						--name "mailserver" \
						-h "$yuming" \
						--restart=always \
						-d analogic/poste.io


					add_app_id

					clear
					echo "poste.io宸茬粡瀹夎瀹屾垚"
					echo "------------------------"
					echo "鎮ㄥ彲浠ヤ娇鐢ㄤ互涓嬪湴鍧€璁块棶poste.io:"
					echo "https://$yuming"
					echo ""

					;;

				2)
					docker rm -f mailserver
					docker rmi -f analogic/poste.i
					yuming=$(cat /home/docker/mail.txt)
					docker run \
						--net=host \
						-e TZ=Europe/Prague \
						-v /home/docker/mail:/data \
						--name "mailserver" \
						-h "$yuming" \
						--restart=always \
						-d analogic/poste.i


					add_app_id

					clear
					echo "poste.io宸茬粡瀹夎瀹屾垚"
					echo "------------------------"
					echo "鎮ㄥ彲浠ヤ娇鐢ㄤ互涓嬪湴鍧€璁块棶poste.io:"
					echo "https://$yuming"
					echo ""
					;;
				3)
					docker rm -f mailserver
					docker rmi -f analogic/poste.io
					rm /home/docker/mail.txt
					rm -rf /home/docker/mail

					sed -i "/\b${app_id}\b/d" /home/docker/appno.txt
					echo "搴旂敤宸插嵏杞?
					;;

				*)
					break
					;;

			esac
			break_end
		done

		  ;;

	  10|rocketchat)

		local app_id="10"
		local app_name="Rocket.Chat鑱婂ぉ绯荤粺"
		local app_text="Rocket.Chat 鏄竴涓紑婧愮殑鍥㈤槦閫氳骞冲彴锛屾敮鎸佸疄鏃惰亰澶┿€侀煶瑙嗛閫氳瘽銆佹枃浠跺叡浜瓑澶氱鍔熻兘锛?
		local app_url="瀹樻柟浠嬬粛: https://www.rocket.chat/"
		local docker_name="rocketchat"
		local docker_port="3897"
		local app_size="2"

		docker_app_install() {
			docker run --name db -d --restart=always \
				-v /home/docker/mongo/dump:/dump \
				mongo:latest --replSet rs5 --oplogSize 256
			sleep 1
			docker exec db mongosh --eval "printjson(rs.initiate())"
			sleep 5
			docker run --name rocketchat --restart=always -p ${docker_port}:3000 --link db --env ROOT_URL=http://localhost --env MONGO_OPLOG_URL=mongodb://db:27017/rs5 -d rocket.chat

			clear
			ip_address
			echo "宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
		}

		docker_app_update() {
			docker rm -f rocketchat
			docker rmi -f rocket.chat:latest
			docker run --name rocketchat --restart=always -p ${docker_port}:3000 --link db --env ROOT_URL=http://localhost --env MONGO_OPLOG_URL=mongodb://db:27017/rs5 -d rocket.chat
			clear
			ip_address
			echo "rocket.chat宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
		}

		docker_app_uninstall() {
			docker rm -f rocketchat
			docker rmi -f rocket.chat
			docker rm -f db
			docker rmi -f mongo:latest
			rm -rf /home/docker/mongo
			echo "搴旂敤宸插嵏杞?
		}

		docker_app_plus
		  ;;



	  11|zentao)
		local app_id="11"
		local docker_name="zentao-server"
		local docker_img="idoop/zentao:latest"
		local docker_port=82


		docker_rum() {


			docker run -d -p ${docker_port}:80 \
			  -e ADMINER_USER="root" -e ADMINER_PASSWD="password" \
			  -e BIND_ADDRESS="false" \
			  -v /home/docker/zentao-server/:/opt/zbox/ \
			  --add-host smtp.exmail.qq.com:163.177.90.125 \
			  --name zentao-server \
			  --restart=always \
			  idoop/zentao:latest


		}

		local docker_describe="绂呴亾鏄€氱敤鐨勯」鐩鐞嗚蒋浠?
		local docker_url="瀹樼綉浠嬬粛: https://www.zentao.net/"
		local docker_use="echo \"鍒濆鐢ㄦ埛鍚? admin\""
		local docker_passwd="echo \"鍒濆瀵嗙爜: 123456\""
		local app_size="2"
		docker_app

		  ;;

	  12|qinglong)
		local app_id="12"
		local docker_name="qinglong"
		local docker_img="whyour/qinglong:latest"
		local docker_port=5700

		docker_rum() {


			docker run -d \
			  -v /home/docker/qinglong/data:/ql/data \
			  -p ${docker_port}:5700 \
			  --name qinglong \
			  --hostname qinglong \
			  --restart=always \
			  whyour/qinglong:latest


		}

		local docker_describe="闈掗緳闈㈡澘鏄竴涓畾鏃朵换鍔＄鐞嗗钩鍙?
		local docker_url="瀹樼綉浠嬬粛: ${gh_proxy}github.com/whyour/qinglong"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;
	  13|cloudreve)

		local app_id="13"
		local app_name="cloudreve缃戠洏"
		local app_text="cloudreve鏄竴涓敮鎸佸瀹朵簯瀛樺偍鐨勭綉鐩樼郴缁?
		local app_url="瑙嗛浠嬬粛: https://www.bilibili.com/video/BV13F4m1c7h7?t=0.1"
		local docker_name="cloudreve"
		local docker_port="5212"
		local app_size="2"

		docker_app_install() {
			cd /home/ && mkdir -p docker/cloud && cd docker/cloud && mkdir temp_data && mkdir -vp cloudreve/{uploads,avatar} && touch cloudreve/conf.ini && touch cloudreve/cloudreve.db && mkdir -p aria2/config && mkdir -p data/aria2 && chmod -R 777 data/aria2
			curl -o /home/docker/cloud/docker-compose.yml ${gh_proxy}raw.githubusercontent.com/kejilion/docker/main/cloudreve-docker-compose.yml
			sed -i "s/5212:5212/${docker_port}:5212/g" /home/docker/cloud/docker-compose.yml
			cd /home/docker/cloud/
			docker compose up -d
			clear
			echo "宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
		}


		docker_app_update() {
			cd /home/docker/cloud/ && docker compose down --rmi all
			cd /home/docker/cloud/ && docker compose up -d
		}


		docker_app_uninstall() {
			cd /home/docker/cloud/ && docker compose down --rmi all
			rm -rf /home/docker/cloud
			echo "搴旂敤宸插嵏杞?
		}

		docker_app_plus
		  ;;

	  14|easyimage)
		local app_id="14"
		local docker_name="easyimage"
		local docker_img="ddsderek/easyimage:latest"
		local docker_port=8014
		docker_rum() {

			docker run -d \
			  --name easyimage \
			  -p ${docker_port}:80 \
			  -e TZ=Asia/Shanghai \
			  -e PUID=1000 \
			  -e PGID=1000 \
			  -v /home/docker/easyimage/config:/app/web/config \
			  -v /home/docker/easyimage/i:/app/web/i \
			  --restart=always \
			  ddsderek/easyimage:latest

		}

		local docker_describe="绠€鍗曞浘搴婃槸涓€涓畝鍗曠殑鍥惧簥绋嬪簭"
		local docker_url="瀹樼綉浠嬬粛: ${gh_proxy}github.com/icret/EasyImages2.0"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  15|emby)
		local app_id="15"
		local docker_name="emby"
		local docker_img="linuxserver/emby:latest"
		local docker_port=8015

		docker_rum() {

			docker run -d --name=emby --restart=always \
				-v /home/docker/emby/config:/config \
				-v /home/docker/emby/share1:/mnt/share1 \
				-v /home/docker/emby/share2:/mnt/share2 \
				-v /mnt/notify:/mnt/notify \
				-p ${docker_port}:8096 \
				-e UID=1000 -e GID=100 -e GIDLIST=100 \
				linuxserver/emby:latest

		}


		local docker_describe="emby鏄竴涓富浠庡紡鏋舵瀯鐨勫獟浣撴湇鍔″櫒杞欢锛屽彲浠ョ敤鏉ユ暣鐞嗘湇鍔″櫒涓婄殑瑙嗛鍜岄煶棰戯紝骞跺皢闊抽鍜岃棰戞祦寮忎紶杈撳埌瀹㈡埛绔澶?
		local docker_url="瀹樼綉浠嬬粛: https://emby.media/"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  16|looking)
		local app_id="16"
		local docker_name="looking-glass"
		local docker_img="wikihostinc/looking-glass-server"
		local docker_port=8016


		docker_rum() {

			docker run -d --name looking-glass --restart=always -p ${docker_port}:80 wikihostinc/looking-glass-server

		}

		local docker_describe="Speedtest娴嬮€熼潰鏉挎槸涓€涓猇PS缃戦€熸祴璇曞伐鍏凤紝澶氶」娴嬭瘯鍔熻兘锛岃繕鍙互瀹炴椂鐩戞帶VPS杩涘嚭绔欐祦閲?
		local docker_url="瀹樼綉浠嬬粛: ${gh_proxy}github.com/wikihost-opensource/als"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;
	  17|adguardhome)

		local app_id="17"
		local docker_name="adguardhome"
		local docker_img="adguard/adguardhome"
		local docker_port=8017

		docker_rum() {

			docker run -d \
				--name adguardhome \
				-v /home/docker/adguardhome/work:/opt/adguardhome/work \
				-v /home/docker/adguardhome/conf:/opt/adguardhome/conf \
				-p 53:53/tcp \
				-p 53:53/udp \
				-p ${docker_port}:3000/tcp \
				--restart=always \
				adguard/adguardhome


		}


		local docker_describe="AdGuardHome鏄竴娆惧叏缃戝箍鍛婃嫤鎴笌鍙嶈窡韪蒋浠讹紝鏈潵灏嗕笉姝㈡槸涓€涓狣NS鏈嶅姟鍣ㄣ€?
		local docker_url="瀹樼綉浠嬬粛: https://hub.docker.com/r/adguard/adguardhome"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;


	  18|onlyoffice)

		local app_id="18"
		local docker_name="onlyoffice"
		local docker_img="onlyoffice/documentserver"
		local docker_port=8018

		docker_rum() {

			docker run -d -p ${docker_port}:80 \
				--restart=always \
				--name onlyoffice \
				-v /home/docker/onlyoffice/DocumentServer/logs:/var/log/onlyoffice  \
				-v /home/docker/onlyoffice/DocumentServer/data:/var/www/onlyoffice/Data  \
				 onlyoffice/documentserver


		}

		local docker_describe="onlyoffice鏄竴娆惧紑婧愮殑鍦ㄧ嚎office宸ュ叿锛屽お寮哄ぇ浜嗭紒"
		local docker_url="瀹樼綉浠嬬粛: https://www.onlyoffice.com/"
		local docker_use=""
		local docker_passwd=""
		local app_size="2"
		docker_app

		  ;;

	  19|safeline)
		send_stats "鎼缓闆锋睜"

		local app_id="19"
		local docker_name=safeline-mgt
		local docker_port=9443
		while true; do
			check_docker_app
			clear
			echo -e "闆锋睜鏈嶅姟 $check_docker"
			echo "闆锋睜鏄暱浜鎶€寮€鍙戠殑WAF绔欑偣闃茬伀澧欑▼搴忛潰鏉匡紝鍙互鍙嶄唬绔欑偣杩涜鑷姩鍖栭槻寰?
			echo "瑙嗛浠嬬粛: https://www.bilibili.com/video/BV1mZ421T74c?t=0.1"
			if docker ps -a --format '{{.Names}}' 2>/dev/null | grep -q "$docker_name"; then
				check_docker_app_ip
			fi
			echo ""

			echo "------------------------"
			echo "1. 瀹夎           2. 鏇存柊           3. 閲嶇疆瀵嗙爜           4. 鍗歌浇"
			echo "------------------------"
			echo "0. 杩斿洖涓婁竴绾ч€夊崟"
			echo "------------------------"
			read -e -p "杈撳叆浣犵殑閫夋嫨: " choice

			case $choice in
				1)
					install_docker
					check_disk_space 5
					bash -c "$(curl -fsSLk https://waf-ce.chaitin.cn/release/latest/setup.sh)"

					add_app_id
					clear
					echo "闆锋睜WAF闈㈡澘宸茬粡瀹夎瀹屾垚"
					check_docker_app_ip
					docker exec safeline-mgt resetadmin

					;;

				2)
					bash -c "$(curl -fsSLk https://waf-ce.chaitin.cn/release/latest/upgrade.sh)"
					docker rmi $(docker images | grep "safeline" | grep "none" | awk '{print $3}')
					echo ""

					add_app_id
					clear
					echo "闆锋睜WAF闈㈡澘宸茬粡鏇存柊瀹屾垚"
					check_docker_app_ip
					;;
				3)
					docker exec safeline-mgt resetadmin
					;;
				4)
					cd /data/safeline
					docker compose down --rmi all

					sed -i "/\b${app_id}\b/d" /home/docker/appno.txt
					echo "濡傛灉浣犳槸榛樿瀹夎鐩綍閭ｇ幇鍦ㄩ」鐩凡缁忓嵏杞姐€傚鏋滀綘鏄嚜瀹氫箟瀹夎鐩綍浣犻渶瑕佸埌瀹夎鐩綍涓嬭嚜琛屾墽琛?"
					echo "docker compose down && docker compose down --rmi all"
					;;
				*)
					break
					;;

			esac
			break_end
		done

		  ;;

	  20|portainer)
		local app_id="20"
		local docker_name="portainer"
		local docker_img="portainer/portainer"
		local docker_port=8020

		docker_rum() {

			docker run -d \
				--name portainer \
				-p ${docker_port}:9000 \
				-v /var/run/docker.sock:/var/run/docker.sock \
				-v /home/docker/portainer:/data \
				--restart=always \
				portainer/portainer

		}


		local docker_describe="portainer鏄竴涓交閲忕骇鐨刣ocker瀹瑰櫒绠＄悊闈㈡澘"
		local docker_url="瀹樼綉浠嬬粛: https://www.portainer.io/"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;

	  21|vscode)
		local app_id="21"
		local docker_name="vscode-web"
		local docker_img="codercom/code-server"
		local docker_port=8021


		docker_rum() {

			docker run -d -p ${docker_port}:8080 -v /home/docker/vscode-web:/home/coder/.local/share/code-server --name vscode-web --restart=always codercom/code-server

		}


		local docker_describe="VScode鏄竴娆惧己澶х殑鍦ㄧ嚎浠ｇ爜缂栧啓宸ュ叿"
		local docker_url="瀹樼綉浠嬬粛: ${gh_proxy}github.com/coder/code-server"
		local docker_use="sleep 3"
		local docker_passwd="docker exec vscode-web cat /home/coder/.config/code-server/config.yaml"
		local app_size="1"
		docker_app
		  ;;


	  22|uptime-kuma)
		local app_id="22"
		local docker_name="uptime-kuma"
		local docker_img="louislam/uptime-kuma:latest"
		local docker_port=8022


		docker_rum() {

			docker run -d \
				--name=uptime-kuma \
				-p ${docker_port}:3001 \
				-v /home/docker/uptime-kuma/uptime-kuma-data:/app/data \
				--restart=always \
				louislam/uptime-kuma:latest

		}


		local docker_describe="Uptime Kuma 鏄撲簬浣跨敤鐨勮嚜鎵樼鐩戞帶宸ュ叿"
		local docker_url="瀹樼綉浠嬬粛: ${gh_proxy}github.com/louislam/uptime-kuma"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  23|memos)
		local app_id="23"
		local docker_name="memos"
		local docker_img="neosmemo/memos:stable"
		local docker_port=8023

		docker_rum() {

			docker run -d --name memos -p ${docker_port}:5230 -v /home/docker/memos:/var/opt/memos --restart=always neosmemo/memos:stable

		}

		local docker_describe="Memos鏄竴娆捐交閲忕骇銆佽嚜鎵樼鐨勫蹇樺綍涓績"
		local docker_url="瀹樼綉浠嬬粛: ${gh_proxy}github.com/usememos/memos"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  24|webtop)
		local app_id="24"
		local docker_name="webtop"
		local docker_img="lscr.io/linuxserver/webtop:latest"
		local docker_port=8024

		docker_rum() {

			read -e -p "璁剧疆鐧诲綍鐢ㄦ埛鍚? " admin
			read -e -p "璁剧疆鐧诲綍鐢ㄦ埛瀵嗙爜: " admin_password
			docker run -d \
			  --name=webtop \
			  --security-opt seccomp=unconfined \
			  -e PUID=1000 \
			  -e PGID=1000 \
			  -e TZ=Etc/UTC \
			  -e SUBFOLDER=/ \
			  -e TITLE=Webtop \
			  -e CUSTOM_USER=${admin} \
			  -e PASSWORD=${admin_password} \
			  -e LC_ALL=zh_CN.UTF-8 \
			  -e DOCKER_MODS=linuxserver/mods:universal-package-install \
			  -e INSTALL_PACKAGES=font-noto-cjk \
			  -p ${docker_port}:3000 \
			  -v /home/docker/webtop/data:/config \
			  -v /var/run/docker.sock:/var/run/docker.sock \
			  --shm-size="1gb" \
			  --restart=always \
			  lscr.io/linuxserver/webtop:latest

		}


		local docker_describe="webtop鍩轰簬Alpine鐨勪腑鏂囩増瀹瑰櫒銆傝嫢IP鏃犳硶璁块棶锛岃娣诲姞鍩熷悕璁块棶銆?
		local docker_url="瀹樼綉浠嬬粛: https://docs.linuxserver.io/images/docker-webtop/"
		local docker_use=""
		local docker_passwd=""
		local app_size="2"
		docker_app
		  ;;

	  25|nextcloud)
		local app_id="25"
		local docker_name="nextcloud"
		local docker_img="nextcloud:latest"
		local docker_port=8025
		local rootpasswd=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16)

		docker_rum() {

			docker run -d --name nextcloud --restart=always -p ${docker_port}:80 -v /home/docker/nextcloud:/var/www/html -e NEXTCLOUD_ADMIN_USER=nextcloud -e NEXTCLOUD_ADMIN_PASSWORD=$rootpasswd nextcloud

		}

		local docker_describe="Nextcloud鎷ユ湁瓒呰繃 400,000 涓儴缃诧紝鏄偍鍙互涓嬭浇鐨勬渶鍙楁杩庣殑鏈湴鍐呭鍗忎綔骞冲彴"
		local docker_url="瀹樼綉浠嬬粛: https://nextcloud.com/"
		local docker_use="echo \"璐﹀彿: nextcloud  瀵嗙爜: $rootpasswd\""
		local docker_passwd=""
		local app_size="3"
		docker_app
		  ;;

	  26|qd)
		local app_id="26"
		local docker_name="qd"
		local docker_img="qdtoday/qd:latest"
		local docker_port=8026

		docker_rum() {

			docker run -d --name qd -p ${docker_port}:80 -v /home/docker/qd/config:/usr/src/app/config qdtoday/qd

		}

		local docker_describe="QD-Today鏄竴涓狧TTP璇锋眰瀹氭椂浠诲姟鑷姩鎵ц妗嗘灦"
		local docker_url="瀹樼綉浠嬬粛: https://qd-today.github.io/qd/zh_CN/"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  27|dockge)
		local app_id="27"
		local docker_name="dockge"
		local docker_img="louislam/dockge:latest"
		local docker_port=8027

		docker_rum() {

			docker run -d --name dockge --restart=always -p ${docker_port}:5001 -v /var/run/docker.sock:/var/run/docker.sock -v /home/docker/dockge/data:/app/data -v  /home/docker/dockge/stacks:/home/docker/dockge/stacks -e DOCKGE_STACKS_DIR=/home/docker/dockge/stacks louislam/dockge

		}

		local docker_describe="dockge鏄竴涓彲瑙嗗寲鐨刣ocker-compose瀹瑰櫒绠＄悊闈㈡澘"
		local docker_url="瀹樼綉浠嬬粛: ${gh_proxy}github.com/louislam/dockge"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  28|speedtest)
		local app_id="28"
		local docker_name="speedtest"
		local docker_img="ghcr.io/librespeed/speedtest"
		local docker_port=8028

		docker_rum() {

			docker run -d -p ${docker_port}:8080 --name speedtest --restart=always ghcr.io/librespeed/speedtest

		}

		local docker_describe="librespeed鏄敤Javascript瀹炵幇鐨勮交閲忕骇閫熷害娴嬭瘯宸ュ叿锛屽嵆寮€鍗崇敤"
		local docker_url="瀹樼綉浠嬬粛: ${gh_proxy}github.com/librespeed/speedtest"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  29|searxng)
		local app_id="29"
		local docker_name="searxng"
		local docker_img="searxng/searxng"
		local docker_port=8029

		docker_rum() {

			docker run -d \
			  --name searxng \
			  --restart=always \
			  -p ${docker_port}:8080 \
			  -v "/home/docker/searxng:/etc/searxng" \
			  searxng/searxng

		}

		local docker_describe="searxng鏄竴涓鏈変笖闅愮鐨勬悳绱㈠紩鎿庣珯鐐?
		local docker_url="瀹樼綉浠嬬粛: https://hub.docker.com/r/alandoyle/searxng"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  30|photoprism)
		local app_id="30"
		local docker_name="photoprism"
		local docker_img="photoprism/photoprism:latest"
		local docker_port=8030
		local rootpasswd=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16)

		docker_rum() {

			docker run -d \
				--name photoprism \
				--restart=always \
				--security-opt seccomp=unconfined \
				--security-opt apparmor=unconfined \
				-p ${docker_port}:2342 \
				-e PHOTOPRISM_UPLOAD_NSFW="true" \
				-e PHOTOPRISM_ADMIN_PASSWORD="$rootpasswd" \
				-v /home/docker/photoprism/storage:/photoprism/storage \
				-v /home/docker/photoprism/Pictures:/photoprism/originals \
				photoprism/photoprism

		}


		local docker_describe="photoprism闈炲父寮哄ぇ鐨勭鏈夌浉鍐岀郴缁?
		local docker_url="瀹樼綉浠嬬粛: https://www.photoprism.app/"
		local docker_use="echo \"璐﹀彿: admin  瀵嗙爜: $rootpasswd\""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;


	  31|s-pdf)
		local app_id="31"
		local docker_name="s-pdf"
		local docker_img="frooodle/s-pdf:latest"
		local docker_port=8031

		docker_rum() {

			docker run -d \
				--name s-pdf \
				--restart=always \
				 -p ${docker_port}:8080 \
				 -v /home/docker/s-pdf/trainingData:/usr/share/tesseract-ocr/5/tessdata \
				 -v /home/docker/s-pdf/extraConfigs:/configs \
				 -v /home/docker/s-pdf/logs:/logs \
				 -e DOCKER_ENABLE_SECURITY=false \
				 frooodle/s-pdf:latest
		}

		local docker_describe="杩欐槸涓€涓己澶х殑鏈湴鎵樼鍩轰簬 Web 鐨?PDF 鎿嶄綔宸ュ叿锛屼娇鐢?docker锛屽厑璁告偍瀵?PDF 鏂囦欢鎵ц鍚勭鎿嶄綔锛屼緥濡傛媶鍒嗗悎骞躲€佽浆鎹€侀噸鏂扮粍缁囥€佹坊鍔犲浘鍍忋€佹棆杞€佸帇缂╃瓑銆?
		local docker_url="瀹樼綉浠嬬粛: ${gh_proxy}github.com/Stirling-Tools/Stirling-PDF"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  32|drawio)
		local app_id="32"
		local docker_name="drawio"
		local docker_img="jgraph/drawio"
		local docker_port=8032

		docker_rum() {

			docker run -d --restart=always --name drawio -p ${docker_port}:8080 -v /home/docker/drawio:/var/lib/drawio jgraph/drawio

		}


		local docker_describe="杩欐槸涓€涓己澶у浘琛ㄧ粯鍒惰蒋浠躲€傛€濈淮瀵煎浘锛屾嫇鎵戝浘锛屾祦绋嬪浘锛岄兘鑳界敾"
		local docker_url="瀹樼綉浠嬬粛: https://www.drawio.com/"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  33|sun-panel)
		local app_id="33"
		local docker_name="sun-panel"
		local docker_img="hslr/sun-panel"
		local docker_port=8033

		docker_rum() {

			docker run -d --restart=always -p ${docker_port}:3002 \
				-v /home/docker/sun-panel/conf:/app/conf \
				-v /home/docker/sun-panel/uploads:/app/uploads \
				-v /home/docker/sun-panel/database:/app/database \
				--name sun-panel \
				hslr/sun-panel

		}

		local docker_describe="Sun-Panel鏈嶅姟鍣ㄣ€丯AS瀵艰埅闈㈡澘銆丠omepage銆佹祻瑙堝櫒棣栭〉"
		local docker_url="瀹樼綉浠嬬粛: https://doc.sun-panel.top/zh_cn/"
		local docker_use="echo \"璐﹀彿: admin@sun.cc  瀵嗙爜: 12345678\""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  34|pingvin-share)
		local app_id="34"
		local docker_name="pingvin-share"
		local docker_img="stonith404/pingvin-share"
		local docker_port=8034

		docker_rum() {

			docker run -d \
				--name pingvin-share \
				--restart=always \
				-p ${docker_port}:3000 \
				-v /home/docker/pingvin-share/data:/opt/app/backend/data \
				stonith404/pingvin-share
		}

		local docker_describe="Pingvin Share 鏄竴涓彲鑷缓鐨勬枃浠跺垎浜钩鍙帮紝鏄?WeTransfer 鐨勪竴涓浛浠ｅ搧"
		local docker_url="瀹樼綉浠嬬粛: ${gh_proxy}github.com/stonith404/pingvin-share"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;


	  35|moments)
		local app_id="35"
		local docker_name="moments"
		local docker_img="kingwrcy/moments:latest"
		local docker_port=8035

		docker_rum() {

			docker run -d --restart=always \
				-p ${docker_port}:3000 \
				-v /home/docker/moments/data:/app/data \
				-v /etc/localtime:/etc/localtime:ro \
				-v /etc/timezone:/etc/timezone:ro \
				--name moments \
				kingwrcy/moments:latest
		}


		local docker_describe="鏋佺畝鏈嬪弸鍦堬紝楂樹豢寰俊鏈嬪弸鍦堬紝璁板綍浣犵殑缇庡ソ鐢熸椿"
		local docker_url="瀹樼綉浠嬬粛: ${gh_proxy}github.com/kingwrcy/moments?tab=readme-ov-file"
		local docker_use="echo \"璐﹀彿: admin  瀵嗙爜: a123456\""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;



	  36|lobe-chat)
		local app_id="36"
		local docker_name="lobe-chat"
		local docker_img="lobehub/lobe-chat:latest"
		local docker_port=8036

		docker_rum() {

			docker run -d -p ${docker_port}:3210 \
				--name lobe-chat \
				--restart=always \
				lobehub/lobe-chat
		}

		local docker_describe="LobeChat鑱氬悎甯傞潰涓婁富娴佺殑AI澶фā鍨嬶紝ChatGPT/Claude/Gemini/Groq/Ollama"
		local docker_url="瀹樼綉浠嬬粛: ${gh_proxy}github.com/lobehub/lobe-chat"
		local docker_use=""
		local docker_passwd=""
		local app_size="2"
		docker_app
		  ;;

	  37|myip)
		local app_id="37"
		local docker_name="myip"
		local docker_img="jason5ng32/myip:latest"
		local docker_port=8037

		docker_rum() {

			docker run -d -p ${docker_port}:18966 --name myip jason5ng32/myip:latest

		}


		local docker_describe="鏄竴涓鍔熻兘IP宸ュ叿绠憋紝鍙互鏌ョ湅鑷繁IP淇℃伅鍙婅繛閫氭€э紝鐢ㄧ綉椤甸潰鏉垮憟鐜?
		local docker_url="瀹樼綉浠嬬粛: ${gh_proxy}github.com/jason5ng32/MyIP/blob/main/README_ZH.md"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  38|xiaoya)
		send_stats "灏忛泤鍏ㄥ妗?
		clear
		install_docker
		check_disk_space 1
		bash -c "$(curl --insecure -fsSL https://ddsrem.com/xiaoya_install.sh)"
		  ;;

	  39|bililive)

		if [ ! -d /home/docker/bililive-go/ ]; then
			mkdir -p /home/docker/bililive-go/ > /dev/null 2>&1
			wget -O /home/docker/bililive-go/config.yml ${gh_proxy}raw.githubusercontent.com/hr3lxphr6j/bililive-go/master/config.yml > /dev/null 2>&1
		fi

		local app_id="39"
		local docker_name="bililive-go"
		local docker_img="chigusa/bililive-go"
		local docker_port=8039

		docker_rum() {

			docker run --restart=always --name bililive-go -v /home/docker/bililive-go/config.yml:/etc/bililive-go/config.yml -v /home/docker/bililive-go/Videos:/srv/bililive -p ${docker_port}:8080 -d chigusa/bililive-go

		}

		local docker_describe="Bililive-go鏄竴涓敮鎸佸绉嶇洿鎾钩鍙扮殑鐩存挱褰曞埗宸ュ叿"
		local docker_url="瀹樼綉浠嬬粛: ${gh_proxy}github.com/hr3lxphr6j/bililive-go"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  40|webssh)
		local app_id="40"
		local docker_name="webssh"
		local docker_img="jrohy/webssh"
		local docker_port=8040
		docker_rum() {
			docker run -d -p ${docker_port}:5032 --restart=always --name webssh -e TZ=Asia/Shanghai jrohy/webssh
		}

		local docker_describe="绠€鏄撳湪绾縮sh杩炴帴宸ュ叿鍜宻ftp宸ュ叿"
		local docker_url="瀹樼綉浠嬬粛: ${gh_proxy}github.com/Jrohy/webssh"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  41|haozi|acepanel)

		local app_id="41"
		local lujing="[ -d "/www/server/panel" ]"
		local panelname="AcePanel 鍘熻€楀瓙闈㈡澘"
		local panelurl="瀹樻柟鍦板潃: ${gh_proxy}github.com/acepanel/panel"

		panel_app_install() {
			cd ~
			bash <(curl -sSLm 10 https://dl.acepanel.net/helper.sh)
		}

		panel_app_manage() {
			acepanel help
		}

		panel_app_uninstall() {
			cd ~
			bash <(curl -sSLm 10 https://dl.acepanel.net/helper.sh)

		}

		install_panel

		  ;;


	  42|nexterm)
		local app_id="42"
		local docker_name="nexterm"
		local docker_img="germannewsmaker/nexterm:latest"
		local docker_port=8042

		docker_rum() {

			ENCRYPTION_KEY=$(openssl rand -hex 32)
			docker run -d \
			  --name nexterm \
			  -e ENCRYPTION_KEY=${ENCRYPTION_KEY} \
			  -p ${docker_port}:6989 \
			  -v /home/docker/nexterm:/app/data \
			  --restart=always \
			  germannewsmaker/nexterm:latest

		}

		local docker_describe="nexterm鏄竴娆惧己澶х殑鍦ㄧ嚎SSH/VNC/RDP杩炴帴宸ュ叿銆?
		local docker_url="瀹樼綉浠嬬粛: ${gh_proxy}github.com/gnmyt/Nexterm"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  43|hbbs)
		local app_id="43"
		local docker_name="hbbs"
		local docker_img="rustdesk/rustdesk-server"
		local docker_port=0000

		docker_rum() {

			docker run --name hbbs -v /home/docker/hbbs/data:/root -td --net=host --restart=always rustdesk/rustdesk-server hbbs

		}


		local docker_describe="rustdesk寮€婧愮殑杩滅▼妗岄潰(鏈嶅姟绔?锛岀被浼艰嚜宸辩殑鍚戞棩钁电鏈嶃€?
		local docker_url="瀹樼綉浠嬬粛: https://rustdesk.com/zh-cn/"
		local docker_use="docker logs hbbs"
		local docker_passwd="echo \"鎶婁綘鐨処P鍜宬ey璁板綍涓嬶紝浼氬湪杩滅▼妗岄潰瀹㈡埛绔腑鐢ㄥ埌銆傚幓44閫夐」瑁呬腑缁х鍚э紒\""
		local app_size="1"
		docker_app
		  ;;

	  44|hbbr)
		local app_id="44"
		local docker_name="hbbr"
		local docker_img="rustdesk/rustdesk-server"
		local docker_port=0000

		docker_rum() {

			docker run --name hbbr -v /home/docker/hbbr/data:/root -td --net=host --restart=always rustdesk/rustdesk-server hbbr

		}

		local docker_describe="rustdesk寮€婧愮殑杩滅▼妗岄潰(涓户绔?锛岀被浼艰嚜宸辩殑鍚戞棩钁电鏈嶃€?
		local docker_url="瀹樼綉浠嬬粛: https://rustdesk.com/zh-cn/"
		local docker_use="echo \"鍓嶅線瀹樼綉涓嬭浇杩滅▼妗岄潰鐨勫鎴风: https://rustdesk.com/zh-cn/\""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  45|registry)
		local app_id="45"
		local docker_name="registry"
		local docker_img="registry:2"
		local docker_port=8045

		docker_rum() {

			docker run -d \
				-p ${docker_port}:5000 \
				--name registry \
				-v /home/docker/registry:/var/lib/registry \
				-e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io \
				--restart=always \
				registry:2

		}

		local docker_describe="Docker Registry 鏄竴涓敤浜庡瓨鍌ㄥ拰鍒嗗彂 Docker 闀滃儚鐨勬湇鍔°€?
		local docker_url="瀹樼綉浠嬬粛: https://hub.docker.com/_/registry"
		local docker_use=""
		local docker_passwd=""
		local app_size="2"
		docker_app
		  ;;

	  46|ghproxy)
		local app_id="46"
		local docker_name="ghproxy"
		local docker_img="wjqserver/ghproxy:latest"
		local docker_port=8046

		docker_rum() {

			docker run -d --name ghproxy --restart=always -p ${docker_port}:8080 -v /home/docker/ghproxy/config:/data/ghproxy/config wjqserver/ghproxy:latest

		}

		local docker_describe="浣跨敤Go瀹炵幇鐨凣HProxy锛岀敤浜庡姞閫熼儴鍒嗗湴鍖篏ithub浠撳簱鐨勬媺鍙栥€?
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/WJQSERVER-STUDIO/ghproxy"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  47|prometheus|grafana)

		local app_id="47"
		local app_name="鏅綏绫充慨鏂洃鎺?
		local app_text="Prometheus+Grafana浼佷笟绾х洃鎺х郴缁?
		local app_url="瀹樼綉浠嬬粛: https://prometheus.io"
		local docker_name="grafana"
		local docker_port="8047"
		local app_size="2"

		docker_app_install() {
			prometheus_install
			clear
			ip_address
			echo "宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
			echo "鍒濆鐢ㄦ埛鍚嶅瘑鐮佸潎涓? admin"
		}

		docker_app_update() {
			docker rm -f node-exporter prometheus grafana
			docker rmi -f prom/node-exporter
			docker rmi -f prom/prometheus:latest
			docker rmi -f grafana/grafana:latest
			docker_app_install
		}

		docker_app_uninstall() {
			docker rm -f node-exporter prometheus grafana
			docker rmi -f prom/node-exporter
			docker rmi -f prom/prometheus:latest
			docker rmi -f grafana/grafana:latest

			rm -rf /home/docker/monitoring
			echo "搴旂敤宸插嵏杞?
		}

		docker_app_plus
		  ;;

	  48|node-exporter)
		local app_id="48"
		local docker_name="node-exporter"
		local docker_img="prom/node-exporter"
		local docker_port=8048

		docker_rum() {

			docker run -d \
				--name=node-exporter \
				-p ${docker_port}:9100 \
				--restart=always \
				prom/node-exporter


		}

		local docker_describe="杩欐槸涓€涓櫘缃楃背淇柉鐨勪富鏈烘暟鎹噰闆嗙粍浠讹紝璇烽儴缃插湪琚洃鎺т富鏈轰笂銆?
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/prometheus/node_exporter"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  49|cadvisor)
		local app_id="49"
		local docker_name="cadvisor"
		local docker_img="gcr.io/cadvisor/cadvisor:latest"
		local docker_port=8049

		docker_rum() {

			docker run -d \
				--name=cadvisor \
				--restart=always \
				-p ${docker_port}:8080 \
				--volume=/:/rootfs:ro \
				--volume=/var/run:/var/run:rw \
				--volume=/sys:/sys:ro \
				--volume=/var/lib/docker/:/var/lib/docker:ro \
				gcr.io/cadvisor/cadvisor:latest \
				-housekeeping_interval=10s \
				-docker_only=true

		}

		local docker_describe="杩欐槸涓€涓櫘缃楃背淇柉鐨勫鍣ㄦ暟鎹噰闆嗙粍浠讹紝璇烽儴缃插湪琚洃鎺т富鏈轰笂銆?
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/google/cadvisor"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;


	  50|changedetection)
		local app_id="50"
		local docker_name="changedetection"
		local docker_img="dgtlmoon/changedetection.io:latest"
		local docker_port=8050

		docker_rum() {

			docker run -d --restart=always -p ${docker_port}:5000 \
				-v /home/docker/datastore:/datastore \
				--name changedetection dgtlmoon/changedetection.io:latest

		}

		local docker_describe="杩欐槸涓€娆剧綉绔欏彉鍖栨娴嬨€佽ˉ璐х洃鎺у拰閫氱煡鐨勫皬宸ュ叿"
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/dgtlmoon/changedetection.io"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;


	  51|pve)
		clear
		send_stats "PVE寮€灏忛浮"
		check_disk_space 1
		curl -L ${gh_proxy}raw.githubusercontent.com/oneclickvirt/pve/main/scripts/install_pve.sh -o install_pve.sh && chmod +x install_pve.sh && bash install_pve.sh
		  ;;


	  52|dpanel)
		local app_id="52"
		local docker_name="dpanel"
		local docker_img="dpanel/dpanel:lite"
		local docker_port=8052

		docker_rum() {

			docker run -d --name dpanel --restart=always \
				-p ${docker_port}:8080 -e APP_NAME=dpanel \
				-v /var/run/docker.sock:/var/run/docker.sock \
				-v /home/docker/dpanel:/dpanel \
				dpanel/dpanel:lite

		}

		local docker_describe="Docker鍙鍖栭潰鏉跨郴缁燂紝鎻愪緵瀹屽杽鐨刣ocker绠＄悊鍔熻兘銆?
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/donknap/dpanel"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  53|llama3)
		local app_id="53"
		local docker_name="ollama"
		local docker_img="ghcr.io/open-webui/open-webui:ollama"
		local docker_port=8053

		docker_rum() {

			docker run -d -p ${docker_port}:8080 -v /home/docker/ollama:/root/.ollama -v /home/docker/ollama/open-webui:/app/backend/data --name ollama --restart=always ghcr.io/open-webui/open-webui:ollama

		}

		local docker_describe="OpenWebUI涓€娆惧ぇ璇█妯″瀷缃戦〉妗嗘灦锛屾帴鍏ュ叏鏂扮殑llama3澶ц瑷€妯″瀷"
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/open-webui/open-webui"
		local docker_use="docker exec ollama ollama run llama3.2:1b"
		local docker_passwd=""
		local app_size="5"
		docker_app
		  ;;

	  54|amh)

		local app_id="54"
		local lujing="[ -d "/www/server/panel" ]"
		local panelname="AMH闈㈡澘"
		local panelurl="瀹樻柟鍦板潃: https://amh.sh/index.htm?amh"

		panel_app_install() {
			cd ~
			wget https://dl.amh.sh/amh.sh && bash amh.sh
		}

		panel_app_manage() {
			panel_app_install
		}

		panel_app_uninstall() {
			panel_app_install
		}

		install_panel
		  ;;


	  55|frps)
		frps_panel
		  ;;

	  56|frpc)
		frpc_panel
		  ;;

	  57|deepseek)
		local app_id="57"
		local docker_name="ollama"
		local docker_img="ghcr.io/open-webui/open-webui:ollama"
		local docker_port=8053

		docker_rum() {

			docker run -d -p ${docker_port}:8080 -v /home/docker/ollama:/root/.ollama -v /home/docker/ollama/open-webui:/app/backend/data --name ollama --restart=always ghcr.io/open-webui/open-webui:ollama

		}

		local docker_describe="OpenWebUI涓€娆惧ぇ璇█妯″瀷缃戦〉妗嗘灦锛屾帴鍏ュ叏鏂扮殑DeepSeek R1澶ц瑷€妯″瀷"
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/open-webui/open-webui"
		local docker_use="docker exec ollama ollama run deepseek-r1:1.5b"
		local docker_passwd=""
		local app_size="5"
		docker_app
		  ;;


	  58|dify)
		local app_id="58"
		local app_name="Dify鐭ヨ瘑搴?
		local app_text="鏄竴娆惧紑婧愮殑澶ц瑷€妯″瀷(LLM) 搴旂敤寮€鍙戝钩鍙般€傝嚜鎵樼璁粌鏁版嵁鐢ㄤ簬AI鐢熸垚"
		local app_url="瀹樻柟缃戠珯: https://docs.dify.ai/zh-hans"
		local docker_name="docker-nginx-1"
		local docker_port="8058"
		local app_size="3"

		docker_app_install() {
			install git
			mkdir -p  /home/docker/ && cd /home/docker/ && git clone ${gh_proxy}github.com/langgenius/dify.git && cd dify/docker && cp .env.example .env
			sed -i "s/^EXPOSE_NGINX_PORT=.*/EXPOSE_NGINX_PORT=${docker_port}/; s/^EXPOSE_NGINX_SSL_PORT=.*/EXPOSE_NGINX_SSL_PORT=8858/" /home/docker/dify/docker/.env

			docker compose up -d

			chown -R 1001:1001 /home/docker/dify/docker/volumes/app/storage
			chmod -R 755 /home/docker/dify/docker/volumes/app/storage
			docker compose down
			docker compose up -d

			clear
			echo "宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
		}

		docker_app_update() {
			cd  /home/docker/dify/docker/ && docker compose down --rmi all
			cd  /home/docker/dify/
			git pull ${gh_proxy}github.com/langgenius/dify.git main > /dev/null 2>&1
			sed -i 's/^EXPOSE_NGINX_PORT=.*/EXPOSE_NGINX_PORT=8058/; s/^EXPOSE_NGINX_SSL_PORT=.*/EXPOSE_NGINX_SSL_PORT=8858/' /home/docker/dify/docker/.env
			cd  /home/docker/dify/docker/ && docker compose up -d
		}

		docker_app_uninstall() {
			cd  /home/docker/dify/docker/ && docker compose down --rmi all
			rm -rf /home/docker/dify
			echo "搴旂敤宸插嵏杞?
		}

		docker_app_plus

		  ;;

	  59|new-api)
		local app_id="59"
		local app_name="NewAPI"
		local app_text="鏂颁竴浠ｅぇ妯″瀷缃戝叧涓嶢I璧勪骇绠＄悊绯荤粺"
		local app_url="瀹樻柟缃戠珯: ${gh_https_url}github.com/Calcium-Ion/new-api"
		local docker_name="new-api"
		local docker_port="8059"
		local app_size="3"

		docker_app_install() {
			install git
			mkdir -p  /home/docker/ && cd /home/docker/ && git clone ${gh_proxy}github.com/Calcium-Ion/new-api.git && cd new-api

			sed -i -e "s/- \"3000:3000\"/- \"${docker_port}:3000\"/g" \
				   -e 's/container_name: redis/container_name: redis-new-api/g' \
				   -e 's/container_name: mysql/container_name: mysql-new-api/g' \
				   docker-compose.yml


			docker compose up -d
			clear
			echo "宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
		}

		docker_app_update() {
			cd  /home/docker/new-api/ && docker compose down --rmi all
			cd  /home/docker/new-api/

			git pull ${gh_proxy}github.com/Calcium-Ion/new-api.git main > /dev/null 2>&1
			sed -i -e "s/- \"3000:3000\"/- \"${docker_port}:3000\"/g" \
				   -e 's/container_name: redis/container_name: redis-new-api/g' \
				   -e 's/container_name: mysql/container_name: mysql-new-api/g' \
				   docker-compose.yml

			docker compose up -d
			clear
			echo "宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip

		}

		docker_app_uninstall() {
			cd  /home/docker/new-api/ && docker compose down --rmi all
			rm -rf /home/docker/new-api
			echo "搴旂敤宸插嵏杞?
		}

		docker_app_plus

		  ;;


	  60|jms)

		local app_id="60"
		local app_name="JumpServer寮€婧愬牎鍨掓満"
		local app_text="鏄竴涓紑婧愮殑鐗规潈璁块棶绠＄悊 (PAM) 宸ュ叿锛岃绋嬪簭鍗犵敤80绔彛涓嶆敮鎸佹坊鍔犲煙鍚嶈闂簡"
		local app_url="瀹樻柟浠嬬粛: ${gh_https_url}github.com/jumpserver/jumpserver"
		local docker_name="jms_web"
		local docker_port="80"
		local app_size="2"

		docker_app_install() {
			curl -sSL ${gh_proxy}github.com/jumpserver/jumpserver/releases/latest/download/quick_start.sh | bash
			clear
			echo "宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
			echo "鍒濆鐢ㄦ埛鍚? admin"
			echo "鍒濆瀵嗙爜: ChangeMe"
		}


		docker_app_update() {
			cd /opt/jumpserver-installer*/
			./jmsctl.sh upgrade
			echo "搴旂敤宸叉洿鏂?
		}


		docker_app_uninstall() {
			cd /opt/jumpserver-installer*/
			./jmsctl.sh uninstall
			cd /opt
			rm -rf jumpserver-installer*/
			rm -rf jumpserver
			echo "搴旂敤宸插嵏杞?
		}

		docker_app_plus
		  ;;

	  61|libretranslate)
		local app_id="61"
		local docker_name="libretranslate"
		local docker_img="libretranslate/libretranslate:latest"
		local docker_port=8061

		docker_rum() {

			docker run -d \
				-p ${docker_port}:5000 \
				--name libretranslate \
				libretranslate/libretranslate \
				--load-only ko,zt,zh,en,ja,pt,es,fr,de,ru

		}

		local docker_describe="鍏嶈垂寮€婧愭満鍣ㄧ炕璇?API锛屽畬鍏ㄨ嚜鎵樼锛屽畠鐨勭炕璇戝紩鎿庣敱寮€婧怉rgos Translate搴撴彁渚涙敮鎸併€?
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/LibreTranslate/LibreTranslate"
		local docker_use=""
		local docker_passwd=""
		local app_size="5"
		docker_app
		  ;;



	  62|ragflow)
		local app_id="62"
		local app_name="RAGFlow鐭ヨ瘑搴?
		local app_text="鍩轰簬娣卞害鏂囨。鐞嗚В鐨勫紑婧?RAG锛堟绱㈠寮虹敓鎴愶級寮曟搸"
		local app_url="瀹樻柟缃戠珯: ${gh_https_url}github.com/infiniflow/ragflow"
		local docker_name="ragflow-server"
		local docker_port="8062"
		local app_size="8"

		docker_app_install() {
			install git
			mkdir -p  /home/docker/ && cd /home/docker/ && git clone ${gh_proxy}github.com/infiniflow/ragflow.git && cd ragflow/docker
			sed -i "s/- 80:80/- ${docker_port}:80/; /- 443:443/d" docker-compose.yml
			docker compose up -d
			clear
			echo "宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
		}

		docker_app_update() {
			cd  /home/docker/ragflow/docker/ && docker compose down --rmi all
			cd  /home/docker/ragflow/
			git pull ${gh_proxy}github.com/infiniflow/ragflow.git main > /dev/null 2>&1
			cd  /home/docker/ragflow/docker/
			sed -i "s/- 80:80/- ${docker_port}:80/; /- 443:443/d" docker-compose.yml
			docker compose up -d
		}

		docker_app_uninstall() {
			cd  /home/docker/ragflow/docker/ && docker compose down --rmi all
			rm -rf /home/docker/ragflow
			echo "搴旂敤宸插嵏杞?
		}

		docker_app_plus

		  ;;


	  63|open-webui)
		local app_id="63"
		local docker_name="open-webui"
		local docker_img="ghcr.io/open-webui/open-webui:main"
		local docker_port=8063

		docker_rum() {

			docker run -d -p ${docker_port}:8080 -v /home/docker/open-webui:/app/backend/data --name open-webui --restart=always ghcr.io/open-webui/open-webui:main

		}

		local docker_describe="OpenWebUI涓€娆惧ぇ璇█妯″瀷缃戦〉妗嗘灦锛屽畼鏂圭簿绠€鐗堟湰锛屾敮鎸佸悇澶фā鍨婣PI鎺ュ叆"
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/open-webui/open-webui"
		local docker_use=""
		local docker_passwd=""
		local app_size="3"
		docker_app
		  ;;

	  64|it-tools)
		local app_id="64"
		local docker_name="it-tools"
		local docker_img="corentinth/it-tools:latest"
		local docker_port=8064

		docker_rum() {
			docker run -d --name it-tools --restart=always -p ${docker_port}:80 corentinth/it-tools:latest
		}

		local docker_describe="瀵瑰紑鍙戜汉鍛樺拰 IT 宸ヤ綔鑰呮潵璇撮潪甯告湁鐢ㄧ殑宸ュ叿"
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/CorentinTh/it-tools"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;


	  65|n8n)
		local app_id="65"
		local docker_name="n8n"
		local docker_img="docker.n8n.io/n8nio/n8n"
		local docker_port=8065

		docker_rum() {

			add_yuming
			mkdir -p /home/docker/n8n
			chmod -R 777 /home/docker/n8n

			docker run -d --name n8n \
			  --restart=always \
			  -p ${docker_port}:5678 \
			  -v /home/docker/n8n:/home/node/.n8n \
			  -e N8N_HOST=${yuming} \
			  -e N8N_PORT=5678 \
			  -e N8N_PROTOCOL=https \
			  -e WEBHOOK_URL=https://${yuming}/ \
			  docker.n8n.io/n8nio/n8n

			ldnmp_Proxy ${yuming} 127.0.0.1 ${docker_port}
			block_container_port "$docker_name" "$ipv4_address"

		}

		local docker_describe="鏄竴娆惧姛鑳藉己澶х殑鑷姩鍖栧伐浣滄祦骞冲彴"
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/n8n-io/n8n"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  66|yt)
		yt_menu_pro
		  ;;


	  67|ddns)
		local app_id="67"
		local docker_name="ddns-go"
		local docker_img="jeessy/ddns-go"
		local docker_port=8067

		docker_rum() {
			docker run -d \
				--name ddns-go \
				--restart=always \
				-p ${docker_port}:9876 \
				-v /home/docker/ddns-go:/root \
				jeessy/ddns-go

		}

		local docker_describe="鑷姩灏嗕綘鐨勫叕缃?IP锛圛Pv4/IPv6锛夊疄鏃舵洿鏂板埌鍚勫ぇ DNS 鏈嶅姟鍟嗭紝瀹炵幇鍔ㄦ€佸煙鍚嶈В鏋愩€?
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/jeessy2/ddns-go"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;

	  68|allinssl)
		local app_id="68"
		local docker_name="allinssl"
		local docker_img="allinssl/allinssl:latest"
		local docker_port=8068

		docker_rum() {
			docker run -d --name allinssl -p ${docker_port}:8888 -v /home/docker/allinssl/data:/www/allinssl/data -e ALLINSSL_USER=allinssl -e ALLINSSL_PWD=allinssldocker -e ALLINSSL_URL=allinssl allinssl/allinssl:latest
		}

		local docker_describe="寮€婧愬厤璐圭殑 SSL 璇佷功鑷姩鍖栫鐞嗗钩鍙?
		local docker_url="瀹樼綉浠嬬粛: https://allinssl.com"
		local docker_use="echo \"瀹夊叏鍏ュ彛: /allinssl\""
		local docker_passwd="echo \"鐢ㄦ埛鍚? allinssl  瀵嗙爜: allinssldocker\""
		local app_size="1"
		docker_app
		  ;;


	  69|sftpgo)
		local app_id="69"
		local docker_name="sftpgo"
		local docker_img="drakkan/sftpgo:latest"
		local docker_port=8069

		docker_rum() {

			mkdir -p /home/docker/sftpgo/data
			mkdir -p /home/docker/sftpgo/config
			chown -R 1000:1000 /home/docker/sftpgo

			docker run -d \
			  --name sftpgo \
			  --restart=always \
			  -p ${docker_port}:8080 \
			  -p 22022:2022 \
			  --mount type=bind,source=/home/docker/sftpgo/data,target=/srv/sftpgo \
			  --mount type=bind,source=/home/docker/sftpgo/config,target=/var/lib/sftpgo \
			  drakkan/sftpgo:latest

		}

		local docker_describe="寮€婧愬厤璐归殢鏃堕殢鍦癝FTP FTP WebDAV 鏂囦欢浼犺緭宸ュ叿"
		local docker_url="瀹樼綉浠嬬粛: https://sftpgo.com/"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;


	  70|astrbot)
		local app_id="70"
		local docker_name="astrbot"
		local docker_img="soulter/astrbot:latest"
		local docker_port=8070

		docker_rum() {

			mkdir -p /home/docker/astrbot/data

			docker run -d \
			  -p ${docker_port}:6185 \
			  -p 6195:6195 \
			  -p 6196:6196 \
			  -p 6199:6199 \
			  -p 11451:11451 \
			  -v /home/docker/astrbot/data:/AstrBot/data \
			  --restart=always \
			  --name astrbot \
			  soulter/astrbot:latest

		}

		local docker_describe="寮€婧怉I鑱婂ぉ鏈哄櫒浜烘鏋讹紝鏀寔寰俊锛孮Q锛孴G鎺ュ叆AI澶фā鍨?
		local docker_url="瀹樼綉浠嬬粛: https://astrbot.app/"
		local docker_use="echo \"鐢ㄦ埛鍚? astrbot  瀵嗙爜: astrbot\""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;


	  71|navidrome)
		local app_id="71"
		local docker_name="navidrome"
		local docker_img="deluan/navidrome:latest"
		local docker_port=8071

		docker_rum() {

			docker run -d \
			  --name navidrome \
			  --restart=always \
			  --user $(id -u):$(id -g) \
			  -v /home/docker/navidrome/music:/music \
			  -v /home/docker/navidrome/data:/data \
			  -p ${docker_port}:4533 \
			  -e ND_LOGLEVEL=info \
			  deluan/navidrome:latest

		}

		local docker_describe="鏄竴涓交閲忋€侀珮鎬ц兘鐨勯煶涔愭祦濯掍綋鏈嶅姟鍣?
		local docker_url="瀹樼綉浠嬬粛: https://www.navidrome.org/"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app
		  ;;


	  72|bitwarden)

		local app_id="72"
		local docker_name="bitwarden"
		local docker_img="vaultwarden/server"
		local docker_port=8072

		docker_rum() {

			docker run -d \
				--name bitwarden \
				--restart=always \
				-p ${docker_port}:80 \
				-v /home/docker/bitwarden/data:/data \
				vaultwarden/server

		}

		local docker_describe="涓€涓綘鍙互鎺у埗鏁版嵁鐨勫瘑鐮佺鐞嗗櫒"
		local docker_url="瀹樼綉浠嬬粛: https://bitwarden.com/"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app


		  ;;



	  73|libretv)

		local app_id="73"
		local docker_name="libretv"
		local docker_img="bestzwei/libretv:latest"
		local docker_port=8073

		docker_rum() {

			read -e -p "璁剧疆LibreTV鐨勭櫥褰曞瘑鐮? " app_passwd

			docker run -d \
			  --name libretv \
			  --restart=always \
			  -p ${docker_port}:8080 \
			  -e PASSWORD=${app_passwd} \
			  bestzwei/libretv:latest

		}

		local docker_describe="鍏嶈垂鍦ㄧ嚎瑙嗛鎼滅储涓庤鐪嬪钩鍙?
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/LibreSpark/LibreTV"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;



	  74|moontv)

		local app_id="74"

		local app_name="moontv绉佹湁褰辫"
		local app_text="鍏嶈垂鍦ㄧ嚎瑙嗛鎼滅储涓庤鐪嬪钩鍙?
		local app_url="瑙嗛浠嬬粛: ${gh_https_url}github.com/MoonTechLab/LunaTV"
		local docker_name="moontv-core"
		local docker_port="8074"
		local app_size="2"

		docker_app_install() {
			read -e -p "璁剧疆鐧诲綍鐢ㄦ埛鍚? " admin
			read -e -p "璁剧疆鐧诲綍鐢ㄦ埛瀵嗙爜: " admin_password
			read -e -p "杈撳叆鎺堟潈鐮? " shouquanma


			mkdir -p /home/docker/moontv
			mkdir -p /home/docker/moontv/config
			mkdir -p /home/docker/moontv/data
			cd /home/docker/moontv

			curl -o /home/docker/moontv/docker-compose.yml ${gh_proxy}raw.githubusercontent.com/kejilion/docker/main/moontv-docker-compose.yml
			sed -i "s/3000:3000/${docker_port}:3000/g" /home/docker/moontv/docker-compose.yml
			sed -i "s|admin_password|${admin_password}|g" /home/docker/moontv/docker-compose.yml
			sed -i "s|admin|${admin}|g" /home/docker/moontv/docker-compose.yml
			sed -i "s|shouquanma|${shouquanma}|g" /home/docker/moontv/docker-compose.yml
			cd /home/docker/moontv/
			docker compose up -d
			clear
			echo "宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
		}


		docker_app_update() {
			cd /home/docker/moontv/ && docker compose down --rmi all
			cd /home/docker/moontv/ && docker compose up -d
		}


		docker_app_uninstall() {
			cd /home/docker/moontv/ && docker compose down --rmi all
			rm -rf /home/docker/moontv
			echo "搴旂敤宸插嵏杞?
		}

		docker_app_plus

		  ;;


	  75|melody)

		local app_id="75"
		local docker_name="melody"
		local docker_img="foamzou/melody:latest"
		local docker_port=8075

		docker_rum() {

			docker run -d \
			  --name melody \
			  --restart=always \
			  -p ${docker_port}:5566 \
			  -v /home/docker/melody/.profile:/app/backend/.profile \
			  foamzou/melody:latest


		}

		local docker_describe="浣犵殑闊充箰绮剧伒锛屾棬鍦ㄥ府鍔╀綘鏇村ソ鍦扮鐞嗛煶涔愩€?
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/foamzou/melody"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app


		  ;;


	  76|dosgame)

		local app_id="76"
		local docker_name="dosgame"
		local docker_img="oldiy/dosgame-web-docker:latest"
		local docker_port=8076

		docker_rum() {
			docker run -d \
				--name dosgame \
				--restart=always \
				-p ${docker_port}:262 \
				oldiy/dosgame-web-docker:latest

		}

		local docker_describe="鏄竴涓腑鏂嘍OS娓告垙鍚堥泦缃戠珯"
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/rwv/chinese-dos-games"
		local docker_use=""
		local docker_passwd=""
		local app_size="2"
		docker_app


		  ;;

	  77|xunlei)

		local app_id="77"
		local docker_name="xunlei"
		local docker_img="cnk3x/xunlei"
		local docker_port=8077

		docker_rum() {

			read -e -p "璁剧疆鐧诲綍鐢ㄦ埛鍚? " app_use
			read -e -p "璁剧疆鐧诲綍瀵嗙爜: " app_passwd

			docker run -d \
			  --name xunlei \
			  --restart=always \
			  --privileged \
			  -e XL_DASHBOARD_USERNAME=${app_use} \
			  -e XL_DASHBOARD_PASSWORD=${app_passwd} \
			  -v /home/docker/xunlei/data:/xunlei/data \
			  -v /home/docker/xunlei/downloads:/xunlei/downloads \
			  -p ${docker_port}:2345 \
			  cnk3x/xunlei

		}

		local docker_describe="杩呴浄浣犵殑绂荤嚎楂橀€烞T纾佸姏涓嬭浇宸ュ叿"
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/cnk3x/xunlei"
		local docker_use="echo \"鎵嬫満鐧诲綍杩呴浄锛屽啀杈撳叆閭€璇风爜锛岄個璇风爜: 杩呴浄鐗涢€歕""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;



	  78|PandaWiki)

		local app_id="78"
		local app_name="PandaWiki"
		local app_text="PandaWiki鏄竴娆続I澶фā鍨嬮┍鍔ㄧ殑寮€婧愭櫤鑳芥枃妗ｇ鐞嗙郴缁燂紝寮虹儓寤鸿涓嶈鑷畾涔夌鍙ｉ儴缃层€?
		local app_url="瀹樻柟浠嬬粛: ${gh_https_url}github.com/chaitin/PandaWiki"
		local docker_name="panda-wiki-nginx"
		local docker_port="2443"
		local app_size="2"

		docker_app_install() {
			bash -c "$(curl -fsSLk https://release.baizhi.cloud/panda-wiki/manager.sh)"
		}

		docker_app_update() {
			docker_app_install
		}


		docker_app_uninstall() {
			docker_app_install
		}

		docker_app_plus
		  ;;



	  79|beszel)

		local app_id="79"
		local docker_name="beszel"
		local docker_img="henrygd/beszel"
		local docker_port=8079

		docker_rum() {

			mkdir -p /home/docker/beszel && \
			docker run -d \
			  --name beszel \
			  --restart=always \
			  -v /home/docker/beszel:/beszel_data \
			  -p ${docker_port}:8090 \
			  henrygd/beszel

		}

		local docker_describe="Beszel杞婚噺鏄撶敤鐨勬湇鍔″櫒鐩戞帶"
		local docker_url="瀹樼綉浠嬬粛: https://beszel.dev/zh/"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;


	  80|linkwarden)

		  local app_id="80"
		  local app_name="linkwarden涔︾绠＄悊"
		  local app_text="涓€涓紑婧愮殑鑷墭绠′功绛剧鐞嗗钩鍙帮紝鏀寔鏍囩銆佹悳绱㈠拰鍥㈤槦鍗忎綔銆?
		  local app_url="瀹樻柟缃戠珯: https://linkwarden.app/"
		  local docker_name="linkwarden-linkwarden-1"
		  local docker_port="8080"
		  local app_size="3"

		  docker_app_install() {
			  install git openssl
			  mkdir -p /home/docker/linkwarden && cd /home/docker/linkwarden

			  # 涓嬭浇瀹樻柟 docker-compose 鍜?env 鏂囦欢
			  curl -O ${gh_proxy}raw.githubusercontent.com/linkwarden/linkwarden/refs/heads/main/docker-compose.yml
			  curl -L ${gh_proxy}raw.githubusercontent.com/linkwarden/linkwarden/refs/heads/main/.env.sample -o ".env"

			  # 鐢熸垚闅忔満瀵嗛挜涓庡瘑鐮?
			  local ADMIN_EMAIL="admin@example.com"
			  local ADMIN_PASSWORD=$(openssl rand -hex 8)

			  sed -i "s|^NEXTAUTH_URL=.*|NEXTAUTH_URL=http://localhost:${docker_port}/api/v1/auth|g" .env
			  sed -i "s|^NEXTAUTH_SECRET=.*|NEXTAUTH_SECRET=$(openssl rand -hex 32)|g" .env
			  sed -i "s|^POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=$(openssl rand -hex 16)|g" .env
			  sed -i "s|^MEILI_MASTER_KEY=.*|MEILI_MASTER_KEY=$(openssl rand -hex 32)|g" .env

			  # 杩藉姞绠＄悊鍛樿处鍙蜂俊鎭?
			  echo "ADMIN_EMAIL=${ADMIN_EMAIL}" >> .env
			  echo "ADMIN_PASSWORD=${ADMIN_PASSWORD}" >> .env

			  sed -i "s/3000:3000/${docker_port}:3000/g" /home/docker/linkwarden/docker-compose.yml

			  # 鍚姩瀹瑰櫒
			  docker compose up -d

			  clear
			  echo "宸茬粡瀹夎瀹屾垚"
		  	  check_docker_app_ip

		  }

		  docker_app_update() {
			  cd /home/docker/linkwarden && docker compose down --rmi all
			  curl -O ${gh_proxy}raw.githubusercontent.com/linkwarden/linkwarden/refs/heads/main/docker-compose.yml
			  curl -L ${gh_proxy}raw.githubusercontent.com/linkwarden/linkwarden/refs/heads/main/.env.sample -o ".env.new"

			  # 淇濈暀鍘熸湰鐨勫彉閲?
			  source .env
			  mv .env.new .env
			  echo "NEXTAUTH_URL=$NEXTAUTH_URL" >> .env
			  echo "NEXTAUTH_SECRET=$NEXTAUTH_SECRET" >> .env
			  echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD" >> .env
			  echo "MEILI_MASTER_KEY=$MEILI_MASTER_KEY" >> .env
			  echo "ADMIN_EMAIL=$ADMIN_EMAIL" >> .env
			  echo "ADMIN_PASSWORD=$ADMIN_PASSWORD" >> .env
			  sed -i "s/3000:3000/${docker_port}:3000/g" /home/docker/linkwarden/docker-compose.yml

			  docker compose up -d
		  }

		  docker_app_uninstall() {
			  cd /home/docker/linkwarden && docker compose down --rmi all
			  rm -rf /home/docker/linkwarden
			  echo "搴旂敤宸插嵏杞?
		  }

		  docker_app_plus

		  ;;



	  81|jitsi)
		  local app_id="81"
		  local app_name="JitsiMeet瑙嗛浼氳"
		  local app_text="涓€涓紑婧愮殑瀹夊叏瑙嗛浼氳瑙ｅ喅鏂规锛屾敮鎸佸浜哄湪绾夸細璁€佸睆骞曞叡浜笌鍔犲瘑閫氫俊銆?
		  local app_url="瀹樻柟缃戠珯: https://jitsi.org/"
		  local docker_name="jitsi"
		  local docker_port="8081"
		  local app_size="3"

		  docker_app_install() {

			  add_yuming
			  mkdir -p /home/docker/jitsi && cd /home/docker/jitsi
			  wget $(wget -q -O - https://api.github.com/repos/jitsi/docker-jitsi-meet/releases/latest | grep zip | cut -d\" -f4)
			  unzip "$(ls -t | head -n 1)"
			  cd "$(ls -dt */ | head -n 1)"
			  cp env.example .env
			  ./gen-passwords.sh
			  mkdir -p ~/.jitsi-meet-cfg/{web,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}
			  sed -i "s|^HTTP_PORT=.*|HTTP_PORT=${docker_port}|" .env
			  sed -i "s|^#PUBLIC_URL=https://meet.example.com:\${HTTPS_PORT}|PUBLIC_URL=https://$yuming:443|" .env
			  docker compose up -d

			  ldnmp_Proxy ${yuming} 127.0.0.1 ${docker_port}
			  block_container_port "$docker_name" "$ipv4_address"

		  }

		  docker_app_update() {
			  cd /home/docker/jitsi
			  cd "$(ls -dt */ | head -n 1)"
			  docker compose down --rmi all
			  docker compose up -d

		  }

		  docker_app_uninstall() {
			  cd /home/docker/jitsi
			  cd "$(ls -dt */ | head -n 1)"
			  docker compose down --rmi all
			  rm -rf /home/docker/jitsi
			  echo "搴旂敤宸插嵏杞?
		  }

		  docker_app_plus

		  ;;



	  82|gpt-load)

		local app_id="82"
		local docker_name="gpt-load"
		local docker_img="tbphp/gpt-load:latest"
		local docker_port=8082

		docker_rum() {

			read -e -p "璁剧疆${docker_name}鐨勭櫥褰曞瘑閽ワ紙sk-寮€澶村瓧姣嶅拰鏁板瓧缁勫悎锛夊: sk-159kejilionyyds163: " app_passwd

			mkdir -p /home/docker/gpt-load && \
			docker run -d --name gpt-load \
				-p ${docker_port}:3001 \
				-e AUTH_KEY=${app_passwd} \
				-v "/home/docker/gpt-load/data":/app/data \
				tbphp/gpt-load:latest

		}

		local docker_describe="楂樻€ц兘AI鎺ュ彛閫忔槑浠ｇ悊鏈嶅姟"
		local docker_url="瀹樼綉浠嬬粛: https://www.gpt-load.com/"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;



	  83|komari)

		local app_id="83"
		local docker_name="komari"
		local docker_img="ghcr.io/komari-monitor/komari:latest"
		local docker_port=8083

		docker_rum() {

			mkdir -p /home/docker/komari && \
			docker run -d \
			  --name komari \
			  -p ${docker_port}:25774 \
			  -v /home/docker/komari:/app/data \
			  -e ADMIN_USERNAME=admin \
			  -e ADMIN_PASSWORD=1212156 \
			  -e TZ=Asia/Shanghai \
			  --restart=always \
			  ghcr.io/komari-monitor/komari:latest

		}

		local docker_describe="杞婚噺绾х殑鑷墭绠℃湇鍔″櫒鐩戞帶宸ュ叿"
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/komari-monitor/komari/tree/main"
		local docker_use="echo \"榛樿璐﹀彿: admin  榛樿瀵嗙爜: 1212156\""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;



	  84|wallos)

		local app_id="84"
		local docker_name="wallos"
		local docker_img="bellamy/wallos:latest"
		local docker_port=8084

		docker_rum() {

			mkdir -p /home/docker/wallos && \
			docker run -d --name wallos \
			  -v /home/docker/wallos/db:/var/www/html/db \
			  -v /home/docker/wallos/logos:/var/www/html/images/uploads/logos \
			  -e TZ=UTC \
			  -p ${docker_port}:80 \
			  --restart=always \
			  bellamy/wallos:latest

		}

		local docker_describe="寮€婧愪釜浜鸿闃呰拷韪櫒锛屽彲鐢ㄤ簬璐㈠姟绠＄悊"
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/ellite/Wallos"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;

	  85|immich)

		  local app_id="85"
		  local app_name="immich鍥剧墖瑙嗛绠＄悊鍣?
		  local app_text="楂樻€ц兘鑷墭绠＄収鐗囧拰瑙嗛绠＄悊瑙ｅ喅鏂规銆?
		  local app_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/immich-app/immich"
		  local docker_name="immich_server"
		  local docker_port="8085"
		  local app_size="3"

		  docker_app_install() {
			  install git openssl wget
			  mkdir -p /home/docker/${docker_name} && cd /home/docker/${docker_name}

			  wget -O docker-compose.yml ${gh_proxy}github.com/immich-app/immich/releases/latest/download/docker-compose.yml
			  wget -O .env ${gh_proxy}github.com/immich-app/immich/releases/latest/download/example.env
			  sed -i "s/2283:2283/${docker_port}:2283/g" /home/docker/${docker_name}/docker-compose.yml

			  docker compose up -d

			  clear
			  echo "宸茬粡瀹夎瀹屾垚"
		  	  check_docker_app_ip

		  }

		  docker_app_update() {
				cd /home/docker/${docker_name} && docker compose down --rmi all
				docker_app_install
		  }

		  docker_app_uninstall() {
			  cd /home/docker/${docker_name} && docker compose down --rmi all
			  rm -rf /home/docker/${docker_name}
			  echo "搴旂敤宸插嵏杞?
		  }

		  docker_app_plus


		  ;;


	  86|jellyfin)

		local app_id="86"
		local docker_name="jellyfin"
		local docker_img="jellyfin/jellyfin"
		local docker_port=8086

		docker_rum() {

			mkdir -p /home/docker/jellyfin/media
			chmod -R 777 /home/docker/jellyfin

			docker run -d \
			  --name jellyfin \
			  --user root \
			  --volume /home/docker/jellyfin/config:/config \
			  --volume /home/docker/jellyfin/cache:/cache \
			  --mount type=bind,source=/home/docker/jellyfin/media,target=/media \
			  -p ${docker_port}:8096 \
			  -p 7359:7359/udp \
			  --restart=always \
			  jellyfin/jellyfin


		}

		local docker_describe="鏄竴娆惧紑婧愬獟浣撴湇鍔″櫒杞欢"
		local docker_url="瀹樼綉浠嬬粛: https://jellyfin.org/"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;


	  87|synctv)

		local app_id="87"
		local docker_name="synctv"
		local docker_img="synctvorg/synctv"
		local docker_port=8087

		docker_rum() {

			docker run -d \
				--name synctv \
				-v /home/docker/synctv:/root/.synctv \
				-p ${docker_port}:8080 \
				--restart=always \
				synctvorg/synctv

		}

		local docker_describe="杩滅▼涓€璧疯鐪嬬數褰卞拰鐩存挱鐨勭▼搴忋€傚畠鎻愪緵浜嗗悓姝ヨ褰便€佺洿鎾€佽亰澶╃瓑鍔熻兘"
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/synctv-org/synctv"
		local docker_use="echo \"鍒濆璐﹀彿鍜屽瘑鐮? root  鐧婚檰鍚庤鍙婃椂淇敼鐧诲綍瀵嗙爜\""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;


	  88|owncast)

		local app_id="88"
		local docker_name="owncast"
		local docker_img="owncast/owncast:latest"
		local docker_port=8088

		docker_rum() {

			docker run -d \
				--name owncast \
				-p ${docker_port}:8080 \
				-p 1935:1935 \
				-v /home/docker/owncast/data:/app/data \
				--restart=always \
				owncast/owncast:latest


		}

		local docker_describe="寮€婧愩€佸厤璐圭殑鑷缓鐩存挱骞冲彴"
		local docker_url="瀹樼綉浠嬬粛: https://owncast.online"
		local docker_use="echo \"璁块棶鍦板潃鍚庨潰甯?/admin 璁块棶绠＄悊鍛橀〉闈""
		local docker_passwd="echo \"鍒濆璐﹀彿: admin  鍒濆瀵嗙爜: abc123  鐧婚檰鍚庤鍙婃椂淇敼鐧诲綍瀵嗙爜\""
		local app_size="1"
		docker_app

		  ;;



	  89|file-code-box)

		local app_id="89"
		local docker_name="file-code-box"
		local docker_img="lanol/filecodebox:latest"
		local docker_port=8089

		docker_rum() {

			docker run -d \
			  --name file-code-box \
			  -p ${docker_port}:12345 \
			  -v /home/docker/file-code-box/data:/app/data \
			  --restart=always \
			  lanol/filecodebox:latest

		}

		local docker_describe="鍖垮悕鍙ｄ护鍒嗕韩鏂囨湰鍜屾枃浠讹紝鍍忔嬁蹇€掍竴鏍峰彇鏂囦欢"
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/vastsa/FileCodeBox"
		local docker_use="echo \"璁块棶鍦板潃鍚庨潰甯?/#/admin 璁块棶绠＄悊鍛橀〉闈""
		local docker_passwd="echo \"绠＄悊鍛樺瘑鐮? FileCodeBox2023\""
		local app_size="1"
		docker_app

		  ;;




	  90|matrix)

		local app_id="90"
		local docker_name="matrix"
		local docker_img="matrixdotorg/synapse:latest"
		local docker_port=8090

		docker_rum() {

			add_yuming

			if [ ! -d /home/docker/matrix/data ]; then
				docker run --rm \
				  -v /home/docker/matrix/data:/data \
				  -e SYNAPSE_SERVER_NAME=${yuming} \
				  -e SYNAPSE_REPORT_STATS=yes \
				  --name matrix \
				  matrixdotorg/synapse:latest generate
			fi

			docker run -d \
			  --name matrix \
			  -v /home/docker/matrix/data:/data \
			  -p ${docker_port}:8008 \
			  --restart=always \
			  matrixdotorg/synapse:latest

			echo "鍒涘缓鍒濆鐢ㄦ埛鎴栫鐞嗗憳銆傝璁剧疆浠ヤ笅鍐呭鐢ㄦ埛鍚嶅拰瀵嗙爜浠ュ強鏄惁涓虹鐞嗗憳銆?
			docker exec -it matrix register_new_matrix_user \
			  http://localhost:8008 \
			  -c /data/homeserver.yaml

			sed -i '/^enable_registration:/d' /home/docker/matrix/data/homeserver.yaml
			sed -i '/^# vim:ft=yaml/i enable_registration: true' /home/docker/matrix/data/homeserver.yaml
			sed -i '/^enable_registration_without_verification:/d' /home/docker/matrix/data/homeserver.yaml
			sed -i '/^# vim:ft=yaml/i enable_registration_without_verification: true' /home/docker/matrix/data/homeserver.yaml

			docker restart matrix

			ldnmp_Proxy ${yuming} 127.0.0.1 ${docker_port}
			block_container_port "$docker_name" "$ipv4_address"

		}

		local docker_describe="Matrix鏄竴涓幓涓績鍖栫殑鑱婂ぉ鍗忚"
		local docker_url="瀹樼綉浠嬬粛: https://matrix.org/"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;



	  91|gitea)

		local app_id="91"

		local app_name="gitea绉佹湁浠ｇ爜浠撳簱"
		local app_text="鍏嶈垂鏂颁竴浠ｇ殑浠ｇ爜鎵樼骞冲彴锛屾彁渚涙帴杩?GitHub 鐨勪娇鐢ㄤ綋楠屻€?
		local app_url="瑙嗛浠嬬粛: ${gh_https_url}github.com/go-gitea/gitea"
		local docker_name="gitea"
		local docker_port="8091"
		local app_size="2"

		docker_app_install() {

			mkdir -p /home/docker/gitea
			mkdir -p /home/docker/gitea/gitea
			mkdir -p /home/docker/gitea/data
			mkdir -p /home/docker/gitea/postgres
			cd /home/docker/gitea

			curl -o /home/docker/gitea/docker-compose.yml ${gh_proxy}raw.githubusercontent.com/kejilion/docker/main/gitea-docker-compose.yml
			sed -i "s/3000:3000/${docker_port}:3000/g" /home/docker/gitea/docker-compose.yml
			cd /home/docker/gitea/
			docker compose up -d
			clear
			echo "宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
		}


		docker_app_update() {
			cd /home/docker/gitea/ && docker compose down --rmi all
			cd /home/docker/gitea/ && docker compose up -d
		}


		docker_app_uninstall() {
			cd /home/docker/gitea/ && docker compose down --rmi all
			rm -rf /home/docker/gitea
			echo "搴旂敤宸插嵏杞?
		}

		docker_app_plus

		  ;;




	  92|filebrowser)

		local app_id="92"
		local docker_name="filebrowser"
		local docker_img="hurlenko/filebrowser"
		local docker_port=8092

		docker_rum() {

			docker run -d \
				--name filebrowser \
				--restart=always \
				-p ${docker_port}:8080 \
				-v /home/docker/filebrowser/data:/data \
				-v /home/docker/filebrowser/config:/config \
				-e FB_BASEURL=/filebrowser \
				hurlenko/filebrowser

		}

		local docker_describe="鏄竴涓熀浜嶹eb鐨勬枃浠剁鐞嗗櫒"
		local docker_url="瀹樼綉浠嬬粛: https://filebrowser.org/"
		local docker_use="docker logs filebrowser"
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;

	93|dufs)

		local app_id="93"
		local docker_name="dufs"
		local docker_img="sigoden/dufs"
		local docker_port=8093

		docker_rum() {

			docker run -d \
			  --name ${docker_name} \
			  --restart=always \
			  -v /home/docker/${docker_name}:/data \
			  -p ${docker_port}:5000 \
			  ${docker_img} /data -A

		}

		local docker_describe="鏋佺畝闈欐€佹枃浠舵湇鍔″櫒锛屾敮鎸佷笂浼犱笅杞?
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/sigoden/dufs"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		;;

	94|gopeed)

		local app_id="94"
		local docker_name="gopeed"
		local docker_img="liwei2633/gopeed"
		local docker_port=8094

		docker_rum() {

			read -e -p "璁剧疆鐧诲綍鐢ㄦ埛鍚? " app_use
			read -e -p "璁剧疆鐧诲綍瀵嗙爜: " app_passwd

			docker run -d \
			  --name ${docker_name} \
			  --restart=always \
			  -v /home/docker/${docker_name}/downloads:/app/Downloads \
			  -v /home/docker/${docker_name}/storage:/app/storage \
			  -p ${docker_port}:9999 \
			  ${docker_img} -u ${app_use} -p ${app_passwd}

		}

		local docker_describe="鍒嗗竷寮忛珮閫熶笅杞藉伐鍏凤紝鏀寔澶氱鍗忚"
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/GopeedLab/gopeed"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		;;



	  95|paperless)

		local app_id="95"

		local app_name="paperless鏂囨。绠＄悊骞冲彴"
		local app_text="寮€婧愮殑鐢靛瓙鏂囨。绠＄悊绯荤粺锛屽畠鐨勪富瑕佺敤閫旀槸鎶婁綘鐨勭焊璐ㄦ枃浠舵暟瀛楀寲骞剁鐞嗚捣鏉ャ€?
		local app_url="瑙嗛浠嬬粛: https://docs.paperless-ngx.com/"
		local docker_name="paperless-webserver-1"
		local docker_port="8095"
		local app_size="2"

		docker_app_install() {

			mkdir -p /home/docker/paperless
			mkdir -p /home/docker/paperless/export
			mkdir -p /home/docker/paperless/consume
			cd /home/docker/paperless

			curl -o /home/docker/paperless/docker-compose.yml ${gh_proxy}raw.githubusercontent.com/paperless-ngx/paperless-ngx/refs/heads/main/docker/compose/docker-compose.postgres-tika.yml
			curl -o /home/docker/paperless/docker-compose.env ${gh_proxy}raw.githubusercontent.com/paperless-ngx/paperless-ngx/refs/heads/main/docker/compose/.env

			sed -i "s/8000:8000/${docker_port}:8000/g" /home/docker/paperless/docker-compose.yml
			cd /home/docker/paperless
			docker compose up -d
			clear
			echo "宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
		}


		docker_app_update() {
			cd /home/docker/paperless/ && docker compose down --rmi all
			docker_app_install
		}


		docker_app_uninstall() {
			cd /home/docker/paperless/ && docker compose down --rmi all
			rm -rf /home/docker/paperless
			echo "搴旂敤宸插嵏杞?
		}

		docker_app_plus

		  ;;



	  96|2fauth)

		local app_id="96"

		local app_name="2FAuth鑷墭绠′簩姝ラ獙璇佸櫒"
		local app_text="鑷墭绠＄殑鍙岄噸韬唤楠岃瘉 (2FA) 璐︽埛绠＄悊鍜岄獙璇佺爜鐢熸垚宸ュ叿銆?
		local app_url="瀹樼綉: ${gh_https_url}github.com/Bubka/2FAuth"
		local docker_name="2fauth"
		local docker_port="8096"
		local app_size="1"

		docker_app_install() {

			add_yuming

			mkdir -p /home/docker/2fauth
			mkdir -p /home/docker/2fauth/data
			chmod -R 777 /home/docker/2fauth/
			cd /home/docker/2fauth

			curl -o /home/docker/2fauth/docker-compose.yml ${gh_proxy}raw.githubusercontent.com/kejilion/docker/main/2fauth-docker-compose.yml

			sed -i "s/8000:8000/${docker_port}:8000/g" /home/docker/2fauth/docker-compose.yml
			sed -i "s/yuming.com/${yuming}/g" /home/docker/2fauth/docker-compose.yml
			cd /home/docker/2fauth
			docker compose up -d

			ldnmp_Proxy ${yuming} 127.0.0.1 ${docker_port}
			block_container_port "$docker_name" "$ipv4_address"

			clear
			echo "宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
		}


		docker_app_update() {
			cd /home/docker/2fauth/ && docker compose down --rmi all
			docker_app_install
		}


		docker_app_uninstall() {
			cd /home/docker/2fauth/ && docker compose down --rmi all
			rm -rf /home/docker/2fauth
			echo "搴旂敤宸插嵏杞?
		}

		docker_app_plus

		  ;;



	97|wgs)

		local app_id="97"
		local docker_name="wireguard"
		local docker_img="lscr.io/linuxserver/wireguard:latest"
		local docker_port=8097

		docker_rum() {

		read -e -p  "璇疯緭鍏ョ粍缃戠殑瀹㈡埛绔暟閲?(榛樿 5): " COUNT
		COUNT=${COUNT:-5}
		read -e -p  "璇疯緭鍏?WireGuard 缃戞 (榛樿 10.13.13.0): " NETWORK
		NETWORK=${NETWORK:-10.13.13.0}

		PEERS=$(seq -f "wg%02g" 1 "$COUNT" | paste -sd,)

		ip link delete wg0 &>/dev/null

		ip_address
		docker run -d \
		  --name=wireguard \
		  --network host \
		  --cap-add=NET_ADMIN \
		  --cap-add=SYS_MODULE \
		  -e PUID=1000 \
		  -e PGID=1000 \
		  -e TZ=Etc/UTC \
		  -e SERVERURL=${ipv4_address} \
		  -e SERVERPORT=51820 \
		  -e PEERS=${PEERS} \
		  -e INTERNAL_SUBNET=${NETWORK} \
		  -e ALLOWEDIPS=${NETWORK}/24 \
		  -e PERSISTENTKEEPALIVE_PEERS=all \
		  -e LOG_CONFS=true \
		  -v /home/docker/wireguard/config:/config \
		  -v /lib/modules:/lib/modules \
		  --restart=always \
		  lscr.io/linuxserver/wireguard:latest


		sleep 3

		docker exec wireguard sh -c "
		f='/config/wg_confs/wg0.conf'
		sed -i 's/51820/${docker_port}/g' \$f
		"

		docker exec wireguard sh -c "
		for d in /config/peer_*; do
		  sed -i 's/51820/${docker_port}/g' \$d/*.conf
		done
		"

		docker exec wireguard sh -c '
		for d in /config/peer_*; do
		  sed -i "/^DNS/d" "$d"/*.conf
		done
		'

		docker exec wireguard sh -c '
		for d in /config/peer_*; do
		  for f in "$d"/*.conf; do
			grep -q "^PersistentKeepalive" "$f" || \
			sed -i "/^AllowedIPs/ a PersistentKeepalive = 25" "$f"
		  done
		done
		'

		docker exec wireguard bash -c '
		for d in /config/peer_*; do
		  cd "$d" || continue
		  conf_file=$(ls *.conf)
		  base_name="${conf_file%.conf}"
		  qrencode -o "$base_name.png" < "$conf_file"
		done
		'

		docker restart wireguard

		sleep 2
		echo
		echo -e "${gl_huang}鎵€鏈夊鎴风浜岀淮鐮侀厤缃? ${gl_bai}"
		docker exec wireguard bash -c 'for i in $(ls /config | grep peer_ | sed "s/peer_//"); do echo "--- $i ---"; /app/show-peer $i; done'
		sleep 2
		echo
		echo -e "${gl_huang}鎵€鏈夊鎴风閰嶇疆浠ｇ爜: ${gl_bai}"
		docker exec wireguard sh -c 'for d in /config/peer_*; do echo "# $(basename $d) "; cat $d/*.conf; echo; done'
		sleep 2
		echo -e "${gl_lv}${COUNT}涓鎴风閰嶇疆鍏ㄩ儴杈撳嚭锛屼娇鐢ㄦ柟娉曞涓嬶細${gl_bai}"
		echo -e "${gl_lv}1. 鎵嬫満涓嬭浇wg鐨凙PP锛屾壂鎻忎笂鏂逛簩缁寸爜锛屽彲浠ュ揩閫熻繛鎺ョ綉缁?{gl_bai}"
		echo -e "${gl_lv}2. Windows涓嬭浇瀹㈡埛绔紝澶嶅埗閰嶇疆浠ｇ爜杩炴帴缃戠粶銆?{gl_bai}"
		echo -e "${gl_lv}3. Linux鐢ㄨ剼鏈儴缃瞁G瀹㈡埛绔紝澶嶅埗閰嶇疆浠ｇ爜杩炴帴缃戠粶銆?{gl_bai}"
		echo -e "${gl_lv}瀹樻柟瀹㈡埛绔笅杞芥柟寮? https://www.wireguard.com/install/${gl_bai}"
		break_end

		}

		local docker_describe="鐜颁唬鍖栥€侀珮鎬ц兘鐨勮櫄鎷熶笓鐢ㄧ綉缁滃伐鍏?
		local docker_url="瀹樼綉浠嬬粛: https://www.wireguard.com/"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		;;


	98|wgc)

		local app_id="98"
		local docker_name="wireguardc"
		local docker_img="kjlion/wireguard:alpine"
		local docker_port=51820

		docker_rum() {

			mkdir -p /home/docker/wireguard/config/

			local CONFIG_FILE="/home/docker/wireguard/config/wg0.conf"

			# 鍒涘缓鐩綍锛堝鏋滀笉瀛樺湪锛?
			mkdir -p "$(dirname "$CONFIG_FILE")"

			echo "璇风矘璐翠綘鐨勫鎴风閰嶇疆锛岃繛缁寜涓ゆ鍥炶溅淇濆瓨锛?

			# 鍒濆鍖栧彉閲?
			input=""
			empty_line_count=0

			# 閫愯璇诲彇鐢ㄦ埛杈撳叆
			while IFS= read -r line; do
				if [[ -z "$line" ]]; then
					((empty_line_count++))
					if [[ $empty_line_count -ge 2 ]]; then
						break
					fi
				else
					empty_line_count=0
					input+="$line"$'\n'
				fi
			done

			# 鍐欏叆閰嶇疆鏂囦欢
			echo "$input" > "$CONFIG_FILE"

			echo "瀹㈡埛绔厤缃凡淇濆瓨鍒?$CONFIG_FILE"

			ip link delete wg0 &>/dev/null

			docker run -d \
			  --name wireguardc \
			  --network host \
			  --cap-add NET_ADMIN \
			  --cap-add SYS_MODULE \
			  -v /home/docker/wireguard/config:/config \
			  -v /lib/modules:/lib/modules:ro \
			  --restart=always \
			  kjlion/wireguard:alpine

			sleep 3

			docker logs wireguardc

		break_end

		}

		local docker_describe="鐜颁唬鍖栥€侀珮鎬ц兘鐨勮櫄鎷熶笓鐢ㄧ綉缁滃伐鍏?
		local docker_url="瀹樼綉浠嬬粛: https://www.wireguard.com/"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		;;


	  99|dsm)

		local app_id="99"

		local app_name="dsm缇ゆ櫀铏氭嫙鏈?
		local app_text="Docker瀹瑰櫒涓殑铏氭嫙DSM"
		local app_url="瀹樼綉: ${gh_https_url}github.com/vdsm/virtual-dsm"
		local docker_name="dsm"
		local docker_port="8099"
		local app_size="16"

		docker_app_install() {

			read -e -p "璁剧疆 CPU 鏍告暟 (榛樿 2): " CPU_CORES
			local CPU_CORES=${CPU_CORES:-2}

			read -e -p "璁剧疆鍐呭瓨澶у皬 (榛樿 4G): " RAM_SIZE
			local RAM_SIZE=${RAM_SIZE:-4}

			mkdir -p /home/docker/dsm
			mkdir -p /home/docker/dsm/dev
			chmod -R 777 /home/docker/dsm/
			cd /home/docker/dsm

			curl -o /home/docker/dsm/docker-compose.yml ${gh_proxy}raw.githubusercontent.com/kejilion/docker/main/dsm-docker-compose.yml

			sed -i "s/5000:5000/${docker_port}:5000/g" /home/docker/dsm/docker-compose.yml
			sed -i "s|CPU_CORES: "2"|CPU_CORES: "${CPU_CORES}"|g" /home/docker/dsm/docker-compose.yml
			sed -i "s|RAM_SIZE: "2G"|RAM_SIZE: "${RAM_SIZE}G"|g" /home/docker/dsm/docker-compose.yml
			cd /home/docker/dsm
			docker compose up -d

			clear
			echo "宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
		}


		docker_app_update() {
			cd /home/docker/dsm/ && docker compose down --rmi all
			docker_app_install
		}


		docker_app_uninstall() {
			cd /home/docker/dsm/ && docker compose down --rmi all
			rm -rf /home/docker/dsm
			echo "搴旂敤宸插嵏杞?
		}

		docker_app_plus

		  ;;



	100|syncthing)

		local app_id="100"
		local docker_name="syncthing"
		local docker_img="syncthing/syncthing:latest"
		local docker_port=8100

		docker_rum() {
			docker run -d \
			  --name=syncthing \
			  --hostname=my-syncthing \
			  --restart=always \
			  -p ${docker_port}:8384 \
			  -p 22000:22000/tcp \
			  -p 22000:22000/udp \
			  -p 21027:21027/udp \
			  -v /home/docker/syncthing:/var/syncthing \
			  syncthing/syncthing:latest
		}

		local docker_describe="寮€婧愮殑鐐瑰鐐规枃浠跺悓姝ュ伐鍏凤紝绫讳技浜?Dropbox銆丷esilio Sync锛屼絾瀹屽叏鍘讳腑蹇冨寲銆?
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/syncthing/syncthing"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		;;


	  101|moneyprinterturbo)
		local app_id="101"
		local app_name="AI瑙嗛鐢熸垚宸ュ叿"
		local app_text="MoneyPrinterTurbo鏄竴娆句娇鐢ˋI澶фā鍨嬪悎鎴愰珮娓呯煭瑙嗛鐨勫伐鍏?
		local app_url="瀹樻柟缃戠珯: ${gh_https_url}github.com/harry0703/MoneyPrinterTurbo"
		local docker_name="moneyprinterturbo"
		local docker_port="8101"
		local app_size="3"

		docker_app_install() {
			install git
			mkdir -p  /home/docker/ && cd /home/docker/ && git clone ${gh_proxy}github.com/harry0703/MoneyPrinterTurbo.git && cd MoneyPrinterTurbo/
			sed -i "s/8501:8501/${docker_port}:8501/g" /home/docker/MoneyPrinterTurbo/docker-compose.yml

			docker compose up -d
			clear
			echo "宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
		}

		docker_app_update() {
			cd  /home/docker/MoneyPrinterTurbo/ && docker compose down --rmi all
			cd  /home/docker/MoneyPrinterTurbo/

			git pull ${gh_proxy}github.com/harry0703/MoneyPrinterTurbo.git main > /dev/null 2>&1
			sed -i "s/8501:8501/${docker_port}:8501/g" /home/docker/MoneyPrinterTurbo/docker-compose.yml
			cd  /home/docker/MoneyPrinterTurbo/ && docker compose up -d
		}

		docker_app_uninstall() {
			cd  /home/docker/MoneyPrinterTurbo/ && docker compose down --rmi all
			rm -rf /home/docker/MoneyPrinterTurbo
			echo "搴旂敤宸插嵏杞?
		}

		docker_app_plus

		  ;;



	  102|vocechat)

		local app_id="102"
		local docker_name="vocechat-server"
		local docker_img="privoce/vocechat-server:latest"
		local docker_port=8102

		docker_rum() {

			docker run -d --restart=always \
			  -p ${docker_port}:3000 \
			  --name vocechat-server \
			  -v /home/docker/vocechat/data:/home/vocechat-server/data \
			  privoce/vocechat-server:latest

		}

		local docker_describe="鏄竴娆炬敮鎸佺嫭绔嬮儴缃茬殑涓汉浜戠ぞ浜ゅ獟浣撹亰澶╂湇鍔?
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/Privoce/vocechat-web"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;


	  103|umami)
		local app_id="103"
		local app_name="Umami缃戠珯缁熻宸ュ叿"
		local app_text="寮€婧愩€佽交閲忋€侀殣绉佸弸濂界殑缃戠珯鍒嗘瀽宸ュ叿锛岀被浼间簬GoogleAnalytics銆?
		local app_url="瀹樻柟缃戠珯: ${gh_https_url}github.com/umami-software/umami"
		local docker_name="umami-umami-1"
		local docker_port="8103"
		local app_size="1"

		docker_app_install() {
			install git
			mkdir -p  /home/docker/ && cd /home/docker/ && git clone ${gh_proxy}github.com/umami-software/umami.git && cd umami
			sed -i "s/3000:3000/${docker_port}:3000/g" /home/docker/umami/docker-compose.yml

			docker compose up -d
			clear
			echo "宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
			echo "鍒濆鐢ㄦ埛鍚? admin"
			echo "鍒濆瀵嗙爜: umami"
		}

		docker_app_update() {
			cd  /home/docker/umami/ && docker compose down --rmi all
			cd  /home/docker/umami/
			git pull ${gh_proxy}github.com/umami-software/umami.git main > /dev/null 2>&1
			sed -i "s/8501:8501/${docker_port}:8501/g" /home/docker/umami/docker-compose.yml
			cd  /home/docker/umami/ && docker compose up -d
		}

		docker_app_uninstall() {
			cd  /home/docker/umami/ && docker compose down --rmi all
			rm -rf /home/docker/umami
			echo "搴旂敤宸插嵏杞?
		}

		docker_app_plus

		  ;;

	  104|nginx-stream)
		stream_panel
		  ;;


	  105|siyuan)

		local app_id="105"
		local docker_name="siyuan"
		local docker_img="b3log/siyuan"
		local docker_port=8105

		docker_rum() {

			read -e -p "璁剧疆鐧诲綍瀵嗙爜: " app_passwd

			docker run -d \
			  --name siyuan \
			  --restart=always \
			  -v /home/docker/siyuan/workspace:/siyuan/workspace \
			  -p ${docker_port}:6806 \
			  -e PUID=1001 \
			  -e PGID=1002 \
			  b3log/siyuan \
			  --workspace=/siyuan/workspace/ \
			  --accessAuthCode="${app_passwd}"

		}

		local docker_describe="鎬濇簮绗旇鏄竴娆鹃殣绉佷紭鍏堢殑鐭ヨ瘑绠＄悊绯荤粺"
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/siyuan-note/siyuan"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;


	  106|drawnix)

		local app_id="106"
		local docker_name="drawnix"
		local docker_img="pubuzhixing/drawnix"
		local docker_port=8106

		docker_rum() {

			docker run -d \
			   --restart=always  \
			   --name drawnix \
			   -p ${docker_port}:80 \
			  pubuzhixing/drawnix

		}

		local docker_describe="鏄竴娆惧己澶х殑寮€婧愮櫧鏉垮伐鍏凤紝闆嗘垚鎬濈淮瀵煎浘銆佹祦绋嬪浘绛夈€?
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/plait-board/drawnix"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;


	  107|pansou)

		local app_id="107"
		local docker_name="pansou"
		local docker_img="ghcr.io/fish2018/pansou-web"
		local docker_port=8107

		docker_rum() {

			docker run -d \
			  --name pansou \
			  --restart=always \
			  -p ${docker_port}:80 \
			  -v /home/docker/pansou/data:/app/data \
			  -v /home/docker/pansou/logs:/app/logs \
			  -e ENABLED_PLUGINS="hunhepan,jikepan,panwiki,pansearch,panta,qupansou,
susu,thepiratebay,wanou,xuexizhinan,panyq,zhizhen,labi,muou,ouge,shandian,
duoduo,huban,cyg,erxiao,miaoso,fox4k,pianku,clmao,wuji,cldi,xiaozhang,
libvio,leijing,xb6v,xys,ddys,hdmoli,yuhuage,u3c3,javdb,clxiong,jutoushe,
sdso,xiaoji,xdyh,haisou,bixin,djgou,nyaa,xinjuc,aikanzy,qupanshe,xdpan,
discourse,yunsou,ahhhhfs,nsgame,gying" \
			  ghcr.io/fish2018/pansou-web

		}

		local docker_describe="PanSou鏄竴涓珮鎬ц兘鐨勭綉鐩樿祫婧愭悳绱PI鏈嶅姟銆?
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/fish2018/pansou"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;




	  108|langbot)
		local app_id="108"
		local app_name="LangBot鑱婂ぉ鏈哄櫒浜?
		local app_text="鏄竴涓紑婧愮殑澶ц瑷€妯″瀷鍘熺敓鍗虫椂閫氫俊鏈哄櫒浜哄紑鍙戝钩鍙?
		local app_url="瀹樻柟缃戠珯: ${gh_https_url}github.com/langbot-app/LangBot"
		local docker_name="langbot_plugin_runtime"
		local docker_port="8108"
		local app_size="1"

		docker_app_install() {
			install git
			mkdir -p  /home/docker/ && cd /home/docker/ && git clone ${gh_proxy}github.com/langbot-app/LangBot && cd LangBot/docker
			sed -i "s/5300:5300/${docker_port}:5300/g" /home/docker/LangBot/docker/docker-compose.yaml

			docker compose up -d
			clear
			echo "宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
		}

		docker_app_update() {
			cd  /home/docker/LangBot/docker && docker compose down --rmi all
			cd  /home/docker/LangBot/
			git pull ${gh_proxy}github.com/langbot-app/LangBot main > /dev/null 2>&1
			sed -i "s/5300:5300/${docker_port}:5300/g" /home/docker/LangBot/docker/docker-compose.yaml
			cd  /home/docker/LangBot/docker/ && docker compose up -d
		}

		docker_app_uninstall() {
			cd  /home/docker/LangBot/docker/ && docker compose down --rmi all
			rm -rf /home/docker/LangBot
			echo "搴旂敤宸插嵏杞?
		}

		docker_app_plus

		  ;;


	  109|zfile)

		local app_id="109"
		local docker_name="zfile"
		local docker_img="zhaojun1998/zfile:latest"
		local docker_port=8109

		docker_rum() {


			docker run -d --name=zfile --restart=always \
				-p ${docker_port}:8080 \
				-v /home/docker/zfile/db:/root/.zfile-v4/db \
				-v /home/docker/zfile/logs:/root/.zfile-v4/logs \
				-v /home/docker/zfile/file:/data/file \
				-v /home/docker/zfile/application.properties:/root/.zfile-v4/application.properties \
				zhaojun1998/zfile:latest


		}

		local docker_describe="鏄竴涓€傜敤浜庝釜浜烘垨灏忓洟闃熺殑鍦ㄧ嚎缃戠洏绋嬪簭銆?
		local docker_url="瀹樼綉浠嬬粛: ${gh_https_url}github.com/zfile-dev/zfile"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;


	  110|karakeep)
		local app_id="110"
		local app_name="karakeep涔︾绠＄悊"
		local app_text="鏄竴娆惧彲鑷鎵樼鐨勪功绛惧簲鐢紝甯︽湁浜哄伐鏅鸿兘鍔熻兘锛屼笓涓烘暟鎹洡绉€呰€岃璁°€?
		local app_url="瀹樻柟缃戠珯: ${gh_https_url}github.com/karakeep-app/karakeep"
		local docker_name="docker-web-1"
		local docker_port="8110"
		local app_size="1"

		docker_app_install() {
			install git
			mkdir -p  /home/docker/ && cd /home/docker/ && git clone ${gh_proxy}github.com/karakeep-app/karakeep.git && cd karakeep/docker && cp .env.sample .env
			sed -i "s/3000:3000/${docker_port}:3000/g" /home/docker/karakeep/docker/docker-compose.yml

			docker compose up -d
			clear
			echo "宸茬粡瀹夎瀹屾垚"
			check_docker_app_ip
		}

		docker_app_update() {
			cd  /home/docker/karakeep/docker/ && docker compose down --rmi all
			cd  /home/docker/karakeep/
			git pull ${gh_proxy}github.com/karakeep-app/karakeep.git main > /dev/null 2>&1
			sed -i "s/3000:3000/${docker_port}:3000/g" /home/docker/karakeep/docker/docker-compose.yml
			cd  /home/docker/karakeep/docker/ && docker compose up -d
		}

		docker_app_uninstall() {
			cd  /home/docker/karakeep/docker/ && docker compose down --rmi all
			rm -rf /home/docker/karakeep
			echo "搴旂敤宸插嵏杞?
		}

		docker_app_plus

		  ;;



	  111|convertx)

		local app_id="111"
		local docker_name="convertx"
		local docker_img="ghcr.io/c4illin/convertx:latest"
		local docker_port=8111

		docker_rum() {

			docker run -d --name=${docker_name} --restart=always \
				-p ${docker_port}:3000 \
				-v /home/docker/convertx:/app/data \
				${docker_img}

		}

		local docker_describe="鏄竴涓姛鑳藉己澶х殑澶氭牸寮忔枃浠惰浆鎹㈠伐鍏凤紙鏀寔鏂囨。銆佸浘鍍忋€侀煶棰戣棰戠瓑锛夊己鐑堝缓璁坊鍔犲煙鍚嶈闂?
		local docker_url="椤圭洰鍦板潃: ${gh_https_url}github.com/c4illin/ConvertX"
		local docker_use=""
		local docker_passwd=""
		local app_size="2"
		docker_app

		  ;;


	  112|lucky)

		local app_id="112"
		local docker_name="lucky"
		local docker_img="gdy666/lucky:v2"
		# 鐢变簬 Lucky 浣跨敤 host 缃戠粶妯″紡锛岃繖閲岀殑绔彛浠呬綔璁板綍/璇存槑鍙傝€冿紝瀹為檯鐢卞簲鐢ㄨ嚜韬帶鍒讹紙榛樿16601锛?
		local docker_port=8112

		docker_rum() {

			docker run -d --name=${docker_name} --restart=always \
				--network host \
				-v /home/docker/lucky/conf:/app/conf \
				-v /var/run/docker.sock:/var/run/docker.sock \
				${docker_img}

			echo "姝ｅ湪绛夊緟 Lucky 鍒濆鍖?.."
			sleep 10
			docker exec lucky /app/lucky -rSetHttpAdminPort ${docker_port}

		}

		local docker_describe="Lucky 鏄竴涓ぇ鍐呯綉绌块€忓強绔彛杞彂绠＄悊宸ュ叿锛屾敮鎸?DDNS銆佸弽鍚戜唬鐞嗐€乄OL 绛夊姛鑳姐€?
		local docker_url="椤圭洰鍦板潃: ${gh_https_url}github.com/gdy666/lucky"
		local docker_use="echo \"榛樿璐﹀彿瀵嗙爜: 666\""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;


	  113|firefox)

		local app_id="113"
		local docker_name="firefox"
		local docker_img="jlesage/firefox:latest"
		local docker_port=8113

		docker_rum() {

			read -e -p "璁剧疆鐧诲綍瀵嗙爜: " admin_password

			docker run -d --name=${docker_name} --restart=always \
				-p ${docker_port}:5800 \
				-v /home/docker/firefox:/config:rw \
				-e ENABLE_CJK_FONT=1 \
				-e WEB_AUDIO=1 \
				-e VNC_PASSWORD="${admin_password}" \
				${docker_img}
		}

		local docker_describe="鏄竴涓繍琛屽湪 Docker 涓殑 Firefox 娴忚鍣紝鏀寔閫氳繃缃戦〉鐩存帴璁块棶妗岄潰鐗堟祻瑙堝櫒鐣岄潰銆?
		local docker_url="椤圭洰鍦板潃: ${gh_https_url}github.com/jlesage/docker-firefox"
		local docker_use=""
		local docker_passwd=""
		local app_size="1"
		docker_app

		  ;;

	  114|Moltbot|ClawdBot|moltbot|clawdbot|openclaw|OpenClaw)
	  	  moltbot_menu
		  ;;


	  b)
	  	clear
	  	send_stats "鍏ㄩ儴搴旂敤澶囦唤"

	  	local backup_filename="app_$(date +"%Y%m%d%H%M%S").tar.gz"
	  	echo -e "${gl_kjlan}姝ｅ湪澶囦唤 $backup_filename ...${gl_bai}"
	  	cd / && tar czvf "$backup_filename" home

	  	while true; do
			clear
			echo "澶囦唤鏂囦欢宸插垱寤? /$backup_filename"
			read -e -p "瑕佷紶閫佸浠芥暟鎹埌杩滅▼鏈嶅姟鍣ㄥ悧锛?Y/N): " choice
			case "$choice" in
			  [Yy])
				read -e -p "璇疯緭鍏ヨ繙绔湇鍔″櫒IP:  " remote_ip
				read -e -p "鐩爣鏈嶅姟鍣⊿SH绔彛 [榛樿22]: " TARGET_PORT
				local TARGET_PORT=${TARGET_PORT:-22}

				if [ -z "$remote_ip" ]; then
				  echo "閿欒: 璇疯緭鍏ヨ繙绔湇鍔″櫒IP銆?
				  continue
				fi
				local latest_tar=$(ls -t /app*.tar.gz | head -1)
				if [ -n "$latest_tar" ]; then
				  ssh-keygen -f "/root/.ssh/known_hosts" -R "$remote_ip"
				  sleep 2  # 娣诲姞绛夊緟鏃堕棿
				  scp -P "$TARGET_PORT" -o StrictHostKeyChecking=no "$latest_tar" "root@$remote_ip:/"
				  echo "鏂囦欢宸蹭紶閫佽嚦杩滅▼鏈嶅姟鍣?鏍圭洰褰曘€?
				else
				  echo "鏈壘鍒拌浼犻€佺殑鏂囦欢銆?
				fi
				break
				;;
			  *)
				echo "娉ㄦ剰: 鐩墠澶囦唤浠呭寘鍚玠ocker椤圭洰锛屼笉鍖呭惈瀹濆锛?panel绛夊缓绔欓潰鏉跨殑鏁版嵁澶囦唤銆?
				break
				;;
			esac
	  	done

		  ;;

	  r)
	  	root_use
	  	send_stats "鍏ㄩ儴搴旂敤杩樺師"
	  	echo "鍙敤鐨勫簲鐢ㄥ浠?
	  	echo "-------------------------"
	  	ls -lt /app*.gz | awk '{print $NF}'
	  	echo ""
	  	read -e -p  "鍥炶溅閿繕鍘熸渶鏂扮殑澶囦唤锛岃緭鍏ュ浠芥枃浠跺悕杩樺師鎸囧畾鐨勫浠斤紝杈撳叆0閫€鍑猴細" filename

	  	if [ "$filename" == "0" ]; then
			  break_end
			  linux_panel
	  	fi

	  	# 濡傛灉鐢ㄦ埛娌℃湁杈撳叆鏂囦欢鍚嶏紝浣跨敤鏈€鏂扮殑鍘嬬缉鍖?
	  	if [ -z "$filename" ]; then
			  local filename=$(ls -t /app*.tar.gz | head -1)
	  	fi

	  	if [ -n "$filename" ]; then
		  	  echo -e "${gl_kjlan}姝ｅ湪瑙ｅ帇 $filename ...${gl_bai}"
		  	  cd / && tar -xzf "$filename"
			  echo "搴旂敤鏁版嵁宸茶繕鍘燂紝鐩墠璇锋墜鍔ㄨ繘鍏ユ寚瀹氬簲鐢ㄨ彍鍗曪紝鏇存柊搴旂敤锛屽嵆鍙繕鍘熷簲鐢ㄣ€?
	  	else
			  echo "娌℃湁鎵惧埌鍘嬬缉鍖呫€?
	  	fi

		  ;;

	  0)
		  kejilion
		  ;;
	  *)
		cd ~
		install git
		if [ ! -d apps/.git ]; then
			timeout 10s git clone ${gh_proxy}github.com/xiaowoniu928/apps.git
		else
			cd apps
			# git pull origin main > /dev/null 2>&1
			timeout 10s git pull ${gh_proxy}github.com/xiaowoniu928/apps.git main > /dev/null 2>&1
		fi
		local custom_app="$HOME/apps/${sub_choice}.conf"
		if [ -f "$custom_app" ]; then
			. "$custom_app"
		else
			echo -e "${gl_hong}閿欒: 鏈壘鍒扮紪鍙蜂负 ${sub_choice} 鐨勫簲鐢ㄩ厤缃?{gl_bai}"
		fi
		  ;;
	esac
	break_end
	sub_choice=""

done
}



linux_work() {

	while true; do
	  clear
	  send_stats "鍚庡彴宸ヤ綔鍖?
	  echo -e "鍚庡彴宸ヤ綔鍖?
	  echo -e "绯荤粺灏嗕负浣犳彁渚涘彲浠ュ悗鍙板父椹昏繍琛岀殑宸ヤ綔鍖猴紝浣犲彲浠ョ敤鏉ユ墽琛岄暱鏃堕棿鐨勪换鍔?
	  echo -e "鍗充娇浣犳柇寮€SSH锛屽伐浣滃尯涓殑浠诲姟涔熶笉浼氫腑鏂紝鍚庡彴甯搁┗浠诲姟銆?
	  echo -e "${gl_huang}鎻愮ず: ${gl_bai}杩涘叆宸ヤ綔鍖哄悗浣跨敤Ctrl+b鍐嶅崟鐙寜d锛岄€€鍑哄伐浣滃尯锛?
	  echo -e "${gl_kjlan}------------------------"
	  echo "褰撳墠宸插瓨鍦ㄧ殑宸ヤ綔鍖哄垪琛?
	  echo -e "${gl_kjlan}------------------------"
	  tmux list-sessions
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}1.   ${gl_bai}1鍙峰伐浣滃尯"
	  echo -e "${gl_kjlan}2.   ${gl_bai}2鍙峰伐浣滃尯"
	  echo -e "${gl_kjlan}3.   ${gl_bai}3鍙峰伐浣滃尯"
	  echo -e "${gl_kjlan}4.   ${gl_bai}4鍙峰伐浣滃尯"
	  echo -e "${gl_kjlan}5.   ${gl_bai}5鍙峰伐浣滃尯"
	  echo -e "${gl_kjlan}6.   ${gl_bai}6鍙峰伐浣滃尯"
	  echo -e "${gl_kjlan}7.   ${gl_bai}7鍙峰伐浣滃尯"
	  echo -e "${gl_kjlan}8.   ${gl_bai}8鍙峰伐浣滃尯"
	  echo -e "${gl_kjlan}9.   ${gl_bai}9鍙峰伐浣滃尯"
	  echo -e "${gl_kjlan}10.  ${gl_bai}10鍙峰伐浣滃尯"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}21.  ${gl_bai}SSH甯搁┗妯″紡 ${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}22.  ${gl_bai}鍒涘缓/杩涘叆宸ヤ綔鍖?
	  echo -e "${gl_kjlan}23.  ${gl_bai}娉ㄥ叆鍛戒护鍒板悗鍙板伐浣滃尯"
	  echo -e "${gl_kjlan}24.  ${gl_bai}鍒犻櫎鎸囧畾宸ヤ綔鍖?
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}0.   ${gl_bai}杩斿洖涓昏彍鍗?
	  echo -e "${gl_kjlan}------------------------${gl_bai}"
	  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice

	  case $sub_choice in

		  1)
			  clear
			  install tmux
			  local SESSION_NAME="work1"
			  send_stats "鍚姩宸ヤ綔鍖?SESSION_NAME"
			  tmux_run

			  ;;
		  2)
			  clear
			  install tmux
			  local SESSION_NAME="work2"
			  send_stats "鍚姩宸ヤ綔鍖?SESSION_NAME"
			  tmux_run
			  ;;
		  3)
			  clear
			  install tmux
			  local SESSION_NAME="work3"
			  send_stats "鍚姩宸ヤ綔鍖?SESSION_NAME"
			  tmux_run
			  ;;
		  4)
			  clear
			  install tmux
			  local SESSION_NAME="work4"
			  send_stats "鍚姩宸ヤ綔鍖?SESSION_NAME"
			  tmux_run
			  ;;
		  5)
			  clear
			  install tmux
			  local SESSION_NAME="work5"
			  send_stats "鍚姩宸ヤ綔鍖?SESSION_NAME"
			  tmux_run
			  ;;
		  6)
			  clear
			  install tmux
			  local SESSION_NAME="work6"
			  send_stats "鍚姩宸ヤ綔鍖?SESSION_NAME"
			  tmux_run
			  ;;
		  7)
			  clear
			  install tmux
			  local SESSION_NAME="work7"
			  send_stats "鍚姩宸ヤ綔鍖?SESSION_NAME"
			  tmux_run
			  ;;
		  8)
			  clear
			  install tmux
			  local SESSION_NAME="work8"
			  send_stats "鍚姩宸ヤ綔鍖?SESSION_NAME"
			  tmux_run
			  ;;
		  9)
			  clear
			  install tmux
			  local SESSION_NAME="work9"
			  send_stats "鍚姩宸ヤ綔鍖?SESSION_NAME"
			  tmux_run
			  ;;
		  10)
			  clear
			  install tmux
			  local SESSION_NAME="work10"
			  send_stats "鍚姩宸ヤ綔鍖?SESSION_NAME"
			  tmux_run
			  ;;

		  21)
			while true; do
			  clear
			  if grep -q 'tmux attach-session -t sshd || tmux new-session -s sshd' ~/.bashrc; then
				  local tmux_sshd_status="${gl_lv}寮€鍚?{gl_bai}"
			  else
				  local tmux_sshd_status="${gl_hui}鍏抽棴${gl_bai}"
			  fi
			  send_stats "SSH甯搁┗妯″紡 "
			  echo -e "SSH甯搁┗妯″紡 ${tmux_sshd_status}"
			  echo "寮€鍚悗SSH杩炴帴鍚庝細鐩存帴杩涘叆甯搁┗妯″紡锛岀洿鎺ュ洖鍒颁箣鍓嶇殑宸ヤ綔鐘舵€併€?
			  echo "------------------------"
			  echo "1. 寮€鍚?           2. 鍏抽棴"
			  echo "------------------------"
			  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
			  echo "------------------------"
			  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " gongzuoqu_del
			  case "$gongzuoqu_del" in
				1)
			  	  install tmux
			  	  local SESSION_NAME="sshd"
			  	  send_stats "鍚姩宸ヤ綔鍖?SESSION_NAME"
				  grep -q "tmux attach-session -t sshd" ~/.bashrc || echo -e "\n# 鑷姩杩涘叆 tmux 浼氳瘽\nif [[ -z \"\$TMUX\" ]]; then\n    tmux attach-session -t sshd || tmux new-session -s sshd\nfi" >> ~/.bashrc
				  source ~/.bashrc
			  	  tmux_run
				  ;;
				2)
				  sed -i '/# 鑷姩杩涘叆 tmux 浼氳瘽/,+4d' ~/.bashrc
				  tmux kill-window -t sshd
				  ;;
				*)
				  break
				  ;;
			  esac
			done
			  ;;

		  22)
			  read -e -p "璇疯緭鍏ヤ綘鍒涘缓鎴栬繘鍏ョ殑宸ヤ綔鍖哄悕绉帮紝濡?001 kj001 work1: " SESSION_NAME
			  tmux_run
			  send_stats "鑷畾涔夊伐浣滃尯"
			  ;;


		  23)
			  read -e -p "璇疯緭鍏ヤ綘瑕佸悗鍙版墽琛岀殑鍛戒护锛屽:curl -fsSL https://get.docker.com | sh: " tmuxd
			  tmux_run_d
			  send_stats "娉ㄥ叆鍛戒护鍒板悗鍙板伐浣滃尯"
			  ;;

		  24)
			  read -e -p "璇疯緭鍏ヨ鍒犻櫎鐨勫伐浣滃尯鍚嶇О: " gongzuoqu_name
			  tmux kill-window -t $gongzuoqu_name
			  send_stats "鍒犻櫎宸ヤ綔鍖?
			  ;;

		  0)
			  kejilion
			  ;;
		  *)
			  echo "鏃犳晥鐨勮緭鍏?"
			  ;;
	  esac
	  break_end

	done


}










# 鏅鸿兘鍒囨崲闀滃儚婧愬嚱鏁?
switch_mirror() {
	# 鍙€夊弬鏁帮紝榛樿涓?false
	local upgrade_software=${1:-false}
	local clean_cache=${2:-false}

	# 鑾峰彇鐢ㄦ埛鍥藉
	local country
	country=$(curl -s ipinfo.io/country)

	echo "妫€娴嬪埌鍥藉锛?country"

	if [ "$country" = "CN" ]; then
		echo "浣跨敤鍥藉唴闀滃儚婧?.."
		bash <(curl -sSL https://linuxmirrors.cn/main.sh) \
		  --source mirrors.huaweicloud.com \
		  --protocol https \
		  --use-intranet-source false \
		  --backup true \
		  --upgrade-software "$upgrade_software" \
		  --clean-cache "$clean_cache" \
		  --ignore-backup-tips \
		  --install-epel false \
		  --pure-mode
	else
		echo "浣跨敤娴峰闀滃儚婧?.."
		if [ -f /etc/os-release ] && grep -qi "oracle" /etc/os-release; then
			bash <(curl -sSL https://linuxmirrors.cn/main.sh) \
			  --source mirrors.xtom.com \
			  --protocol https \
			  --use-intranet-source false \
			  --backup true \
			  --upgrade-software "$upgrade_software" \
			  --clean-cache "$clean_cache" \
			  --ignore-backup-tips \
			  --install-epel false \
			  --pure-mode
		else
			bash <(curl -sSL https://linuxmirrors.cn/main.sh) \
				--use-official-source true \
				--protocol https \
				--use-intranet-source false \
				--backup true \
				--upgrade-software "$upgrade_software" \
				--clean-cache "$clean_cache" \
				--ignore-backup-tips \
				--install-epel false \
				--pure-mode
		fi
	fi
}


fail2ban_panel() {
		  root_use
		  send_stats "ssh闃插尽"
		  while true; do

				check_f2b_status
				echo -e "SSH闃插尽绋嬪簭 $check_f2b_status"
				echo "fail2ban鏄竴涓猄SH闃叉鏆村姏鐮磋В宸ュ叿"
				echo "瀹樼綉浠嬬粛: ${gh_proxy}github.com/fail2ban/fail2ban"
				echo "------------------------"
				echo "1. 瀹夎闃插尽绋嬪簭"
				echo "------------------------"
				echo "2. 鏌ョ湅SSH鎷︽埅璁板綍"
				echo "3. 鏃ュ織瀹炴椂鐩戞帶"
				echo "------------------------"
				echo "9. 鍗歌浇闃插尽绋嬪簭"
				echo "------------------------"
				echo "0. 杩斿洖涓婁竴绾ч€夊崟"
				echo "------------------------"
				read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice
				case $sub_choice in
					1)
						f2b_install_sshd
						cd ~
						f2b_status
						break_end
						;;
					2)
						echo "------------------------"
						f2b_sshd
						echo "------------------------"
						break_end
						;;
					3)
						tail -f /var/log/fail2ban.log
						break
						;;
					9)
						remove fail2ban
						rm -rf /etc/fail2ban
						echo "Fail2Ban闃插尽绋嬪簭宸插嵏杞?
						break
						;;
					*)
						break
						;;
				esac
		  done

}





net_menu() {

	send_stats "缃戝崱绠＄悊宸ュ叿"
	show_nics() {
		echo "================ 褰撳墠缃戝崱淇℃伅 ================"
		printf "%-18s %-12s %-20s %-26s\n" "缃戝崱鍚? "鐘舵€? "IP鍦板潃" "MAC鍦板潃"
		echo "------------------------------------------------"
		for nic in $(ls /sys/class/net); do
			state=$(cat /sys/class/net/$nic/operstate 2>/dev/null)
			ipaddr=$(ip -4 addr show $nic | awk '/inet /{print $2}' | head -n1)
			mac=$(cat /sys/class/net/$nic/address 2>/dev/null)
			printf "%-15s %-10s %-18s %-20s\n" "$nic" "$state" "${ipaddr:-鏃爙" "$mac"
		done
		echo "================================================"
	}

	while true; do
		clear
		show_nics
		echo
		echo "=========== 缃戝崱绠＄悊鑿滃崟 ==========="
		echo "1. 鍚敤缃戝崱"
		echo "2. 绂佺敤缃戝崱"
		echo "3. 鏌ョ湅缃戝崱璇︾粏淇℃伅"
		echo "4. 鍒锋柊缃戝崱淇℃伅"
		echo "0. 杩斿洖涓婁竴绾ч€夊崟"
		echo "===================================="
		read -erp "璇烽€夋嫨鎿嶄綔: " choice

		case $choice in
			1)
				send_stats "鍚敤缃戝崱"
				read -erp "璇疯緭鍏ヨ鍚敤鐨勭綉鍗″悕: " nic
				if ip link show "$nic" &>/dev/null; then
					ip link set "$nic" up && echo "鉁?缃戝崱 $nic 宸插惎鐢?
				else
					echo "鉁?缃戝崱涓嶅瓨鍦?
				fi
				read -erp "鎸夊洖杞︾户缁?.."
				;;
			2)
				send_stats "绂佺敤缃戝崱"
				read -erp "璇疯緭鍏ヨ绂佺敤鐨勭綉鍗″悕: " nic
				if ip link show "$nic" &>/dev/null; then
					ip link set "$nic" down && echo "鉁?缃戝崱 $nic 宸茬鐢?
				else
					echo "鉁?缃戝崱涓嶅瓨鍦?
				fi
				read -erp "鎸夊洖杞︾户缁?.."
				;;
			3)
				send_stats "鏌ョ湅缃戝崱璇︽儏"
				read -erp "璇疯緭鍏ヨ鏌ョ湅鐨勭綉鍗″悕: " nic
				if ip link show "$nic" &>/dev/null; then
					echo "========== $nic 璇︾粏淇℃伅 =========="
					ip addr show "$nic"
					ethtool "$nic" 2>/dev/null | head -n 10
				else
					echo "鉁?缃戝崱涓嶅瓨鍦?
				fi
				read -erp "鎸夊洖杞︾户缁?.."
				;;
			4)
				send_stats "鍒锋柊缃戝崱淇℃伅"
				continue
				;;
			*)
				break
				;;
		esac
	done
}



log_menu() {
	send_stats "绯荤粺鏃ュ織绠＄悊宸ュ叿"

	show_log_overview() {
		echo "============= 绯荤粺鏃ュ織姒傝 ============="
		echo "涓绘満鍚? $(hostname)"
		echo "绯荤粺鏃堕棿: $(date)"
		echo
		echo "[ /var/log 鐩綍鍗犵敤 ]"
		du -sh /var/log 2>/dev/null
		echo
		echo "[ journal 鏃ュ織鍗犵敤 ]"
		journalctl --disk-usage 2>/dev/null
		echo "========================================"
	}

	while true; do
		clear
		show_log_overview
		echo
		echo "=========== 绯荤粺鏃ュ織绠＄悊鑿滃崟 ==========="
		echo "1. 鏌ョ湅鏈€杩戠郴缁熸棩蹇楋紙journal锛?
		echo "2. 鏌ョ湅鎸囧畾鏈嶅姟鏃ュ織"
		echo "3. 鏌ョ湅鐧诲綍/瀹夊叏鏃ュ織"
		echo "4. 瀹炴椂璺熻釜鏃ュ織"
		echo "5. 娓呯悊鏃?journal 鏃ュ織"
		echo "0. 杩斿洖涓婁竴绾ч€夊崟"
		echo "======================================="
		read -erp "璇烽€夋嫨鎿嶄綔: " choice

		case $choice in
			1)
				send_stats "鏌ョ湅鏈€杩戞棩蹇?
				read -erp "鏌ョ湅鏈€杩戝灏戣鏃ュ織锛焄榛樿 100]: " lines
				lines=${lines:-100}
				journalctl -n "$lines" --no-pager
				read -erp "鎸夊洖杞︾户缁?.."
				;;
			2)
				send_stats "鏌ョ湅鎸囧畾鏈嶅姟鏃ュ織"
				read -erp "璇疯緭鍏ユ湇鍔″悕锛堝 sshd銆乶ginx锛? " svc
				if systemctl list-unit-files | grep -q "^$svc"; then
					journalctl -u "$svc" -n 100 --no-pager
				else
					echo "鉁?鏈嶅姟涓嶅瓨鍦ㄦ垨鏃犳棩蹇?
				fi
				read -erp "鎸夊洖杞︾户缁?.."
				;;
			3)
				send_stats "鏌ョ湅鐧诲綍/瀹夊叏鏃ュ織"
				echo "====== 鏈€杩戠櫥褰曟棩蹇?======"
				last -n 10
				echo
				echo "====== 璁よ瘉鏃ュ織 ======"
				if [ -f /var/log/secure ]; then
					tail -n 20 /var/log/secure
				elif [ -f /var/log/auth.log ]; then
					tail -n 20 /var/log/auth.log
				else
					echo "鏈壘鍒板畨鍏ㄦ棩蹇楁枃浠?
				fi
				read -erp "鎸夊洖杞︾户缁?.."
				;;
			4)
				send_stats "瀹炴椂璺熻釜鏃ュ織"
				echo "1) 绯荤粺鏃ュ織"
				echo "2) 鎸囧畾鏈嶅姟鏃ュ織"
				read -erp "閫夋嫨璺熻釜绫诲瀷: " t
				if [ "$t" = "1" ]; then
					journalctl -f
				elif [ "$t" = "2" ]; then
					read -erp "杈撳叆鏈嶅姟鍚? " svc
					journalctl -u "$svc" -f
				else
					echo "鏃犳晥閫夋嫨"
				fi
				;;
			5)
				send_stats "娓呯悊鏃?journal 鏃ュ織"
				echo "鈿狅笍 娓呯悊 journal 鏃ュ織锛堝畨鍏ㄦ柟寮忥級"
				echo "1) 淇濈暀鏈€杩?7 澶?
				echo "2) 淇濈暀鏈€杩?3 澶?
				echo "3) 闄愬埗鏃ュ織鏈€澶?500M"
				read -erp "璇烽€夋嫨娓呯悊鏂瑰紡: " c
				case $c in
					1) journalctl --vacuum-time=7d ;;
					2) journalctl --vacuum-time=3d ;;
					3) journalctl --vacuum-size=500M ;;
					*) echo "鏃犳晥閫夐」" ;;
				esac
				echo "鉁?journal 鏃ュ織娓呯悊瀹屾垚"
				sleep 2
				;;
			*)
				break
				;;
		esac
	done
}



env_menu() {

	BASHRC="$HOME/.bashrc"
	PROFILE="$HOME/.profile"

	send_stats "绯荤粺鍙橀噺绠＄悊宸ュ叿"

	show_env_vars() {
		clear
		send_stats "褰撳墠宸茬敓鏁堢幆澧冨彉閲?
		echo "========== 褰撳墠宸茬敓鏁堢幆澧冨彉閲忥紙鑺傞€夛級 =========="
		printf "%-20s %s\n" "鍙橀噺鍚? "鍊?
		echo "-----------------------------------------------"
		for v in USER HOME SHELL LANG PWD; do
			printf "%-20s %s\n" "$v" "${!v}"
		done

		echo
		echo "PATH:"
		echo "$PATH" | tr ':' '\n' | nl -ba

		echo
		echo "========== 閰嶇疆鏂囦欢涓畾涔夌殑鍙橀噺锛堣В鏋愶級 =========="

		parse_file_vars() {
			local file="$1"
			[ -f "$file" ] || return

			echo
			echo ">>> 鏉ユ簮鏂囦欢锛?file"
			echo "-----------------------------------------------"

			# 鎻愬彇 export VAR=xxx 鎴?VAR=xxx
			grep -Ev '^\s*#|^\s*$' "$file" \
			| grep -E '^(export[[:space:]]+)?[A-Za-z_][A-Za-z0-9_]*=' \
			| while read -r line; do
				var=$(echo "$line" | sed -E 's/^(export[[:space:]]+)?([A-Za-z_][A-Za-z0-9_]*).*/\2/')
				val=$(echo "$line" | sed -E 's/^[^=]+=//')
				printf "%-20s %s\n" "$var" "$val"
			done
		}

		parse_file_vars "$HOME/.bashrc"
		parse_file_vars "$HOME/.profile"

		echo
		echo "==============================================="
		read -erp "鎸夊洖杞︾户缁?.."
	}


	view_file() {
		local file="$1"
		send_stats "鏌ョ湅鍙橀噺鏂囦欢 $file"
		clear
		if [ -f "$file" ]; then
			echo "========== 鏌ョ湅鏂囦欢锛?file =========="
			cat -n "$file"
			echo "===================================="
		else
			echo "鏂囦欢涓嶅瓨鍦細$file"
		fi
		read -erp "鎸夊洖杞︾户缁?.."
	}

	edit_file() {
		local file="$1"
		send_stats "缂栬緫鍙橀噺鏂囦欢 $file"
		install nano
		nano "$file"
	}

	source_files() {
		echo "姝ｅ湪閲嶆柊鍔犺浇鐜鍙橀噺..."
		send_stats "姝ｅ湪閲嶆柊鍔犺浇鐜鍙橀噺"
		source "$BASHRC"
		source "$PROFILE"
		echo "鉁?鐜鍙橀噺宸查噸鏂板姞杞?
		read -erp "鎸夊洖杞︾户缁?.."
	}

	while true; do
		clear
		echo "=========== 绯荤粺鐜鍙橀噺绠＄悊 =========="
		echo "褰撳墠鐢ㄦ埛锛?USER"
		echo "--------------------------------------"
		echo "1. 鏌ョ湅褰撳墠甯哥敤鐜鍙橀噺"
		echo "2. 鏌ョ湅 ~/.bashrc"
		echo "3. 鏌ョ湅 ~/.profile"
		echo "4. 缂栬緫 ~/.bashrc"
		echo "5. 缂栬緫 ~/.profile"
		echo "6. 閲嶆柊鍔犺浇鐜鍙橀噺锛坰ource锛?
		echo "--------------------------------------"
		echo "0. 杩斿洖涓婁竴绾ч€夊崟"
		echo "--------------------------------------"
		read -erp "璇烽€夋嫨鎿嶄綔: " choice

		case "$choice" in
			1)
				show_env_vars
				;;
			2)
				view_file "$BASHRC"
				;;
			3)
				view_file "$PROFILE"
				;;
			4)
				edit_file "$BASHRC"
				;;
			5)
				edit_file "$PROFILE"
				;;
			6)
				source_files
				;;
			0)
				break
				;;
			*)
				echo "鏃犳晥閫夐」"
				sleep 1
				;;
		esac
	done
}


create_user_with_sshkey() {
	local new_username="$1"
	local is_sudo="${2:-false}"
	local sshkey_vl

	if [[ -z "$new_username" ]]; then
		echo "鐢ㄦ硶锛歝reate_user_with_sshkey <鐢ㄦ埛鍚?"
		return 1
	fi

	# 鍒涘缓鐢ㄦ埛
	useradd -m -s /bin/bash "$new_username" || return 1

	echo "瀵煎叆鍏挜鑼冧緥锛?
	echo "  - URL锛?     ${gh_https_url}github.com/torvalds.keys"
	echo "  - 鐩存帴绮樿创锛?ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI..."
	read -e -p "璇峰鍏?${new_username} 鐨勫叕閽? " sshkey_vl

	case "$sshkey_vl" in
		http://*|https://*)
			send_stats "浠?URL 瀵煎叆 SSH 鍏挜"
			fetch_remote_ssh_keys "$sshkey_vl" "/home/$new_username"
			;;
		ssh-rsa*|ssh-ed25519*|ssh-ecdsa*)
			send_stats "鍏挜鐩存帴瀵煎叆"
			import_sshkey "$sshkey_vl" "/home/$new_username"
			;;
		*)
			echo "閿欒锛氭湭鐭ュ弬鏁?'$sshkey_vl'"
			return 1
			;;
	esac


	# 淇鏉冮檺
	chown -R "$new_username:$new_username" "/home/$new_username/.ssh"

	install sudo

	# sudo 鍏嶅瘑
	if [[ "$is_sudo" == "true" ]]; then
		cat >"/etc/sudoers.d/$new_username" <<EOF
$new_username ALL=(ALL) NOPASSWD:ALL
EOF
		chmod 440 "/etc/sudoers.d/$new_username"
	fi

	sed -i '/^\s*#\?\s*UsePAM\s\+/d' /etc/ssh/sshd_config
	echo 'UsePAM yes' >> /etc/ssh/sshd_config
	passwd -l "$new_username" &>/dev/null
	restart_ssh

	echo "鐢ㄦ埛 $new_username 鍒涘缓瀹屾垚"
}















linux_Settings() {

	while true; do
	  clear
	  # send_stats "绯荤粺宸ュ叿"
	  echo -e "绯荤粺宸ュ叿"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}1.   ${gl_bai}璁剧疆鑴氭湰鍚姩蹇嵎閿?                ${gl_kjlan}2.   ${gl_bai}淇敼鐧诲綍瀵嗙爜"
	  echo -e "${gl_kjlan}3.   ${gl_bai}鐢ㄦ埛瀵嗙爜鐧诲綍妯″紡                   ${gl_kjlan}4.   ${gl_bai}瀹夎Python鎸囧畾鐗堟湰"
	  echo -e "${gl_kjlan}5.   ${gl_bai}寮€鏀炬墍鏈夌鍙?                      ${gl_kjlan}6.   ${gl_bai}淇敼SSH杩炴帴绔彛"
	  echo -e "${gl_kjlan}7.   ${gl_bai}浼樺寲DNS鍦板潃                        ${gl_kjlan}8.   ${gl_bai}涓€閿噸瑁呯郴缁?${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}9.   ${gl_bai}绂佺敤ROOT璐︽埛鍒涘缓鏂拌处鎴?            ${gl_kjlan}10.  ${gl_bai}鍒囨崲浼樺厛ipv4/ipv6"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}11.  ${gl_bai}鏌ョ湅绔彛鍗犵敤鐘舵€?                  ${gl_kjlan}12.  ${gl_bai}淇敼铏氭嫙鍐呭瓨澶у皬"
	  echo -e "${gl_kjlan}13.  ${gl_bai}鐢ㄦ埛绠＄悊                           ${gl_kjlan}14.  ${gl_bai}鐢ㄦ埛/瀵嗙爜鐢熸垚鍣?
	  echo -e "${gl_kjlan}15.  ${gl_bai}绯荤粺鏃跺尯璋冩暣                       ${gl_kjlan}16.  ${gl_bai}璁剧疆BBR3鍔犻€?
	  echo -e "${gl_kjlan}17.  ${gl_bai}闃茬伀澧欓珮绾х鐞嗗櫒                   ${gl_kjlan}18.  ${gl_bai}淇敼涓绘満鍚?
	  echo -e "${gl_kjlan}19.  ${gl_bai}鍒囨崲绯荤粺鏇存柊婧?                    ${gl_kjlan}20.  ${gl_bai}瀹氭椂浠诲姟绠＄悊"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}21.  ${gl_bai}鏈満host瑙ｆ瀽                       ${gl_kjlan}22.  ${gl_bai}SSH闃插尽绋嬪簭"
	  echo -e "${gl_kjlan}23.  ${gl_bai}闄愭祦鑷姩鍏虫満                       ${gl_kjlan}24.  ${gl_bai}鐢ㄦ埛瀵嗛挜鐧诲綍妯″紡"
	  echo -e "${gl_kjlan}25.  ${gl_bai}TG-bot绯荤粺鐩戞帶棰勮                 ${gl_kjlan}26.  ${gl_bai}淇OpenSSH楂樺嵄婕忔礊"
	  echo -e "${gl_kjlan}27.  ${gl_bai}绾㈠附绯籐inux鍐呮牳鍗囩骇                ${gl_kjlan}28.  ${gl_bai}Linux绯荤粺鍐呮牳鍙傛暟浼樺寲 ${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}29.  ${gl_bai}鐥呮瘨鎵弿宸ュ叿 ${gl_huang}鈽?{gl_bai}                     ${gl_kjlan}30.  ${gl_bai}鏂囦欢绠＄悊鍣?
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}31.  ${gl_bai}鍒囨崲绯荤粺璇█                       ${gl_kjlan}32.  ${gl_bai}鍛戒护琛岀編鍖栧伐鍏?${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}33.  ${gl_bai}璁剧疆绯荤粺鍥炴敹绔?                    ${gl_kjlan}34.  ${gl_bai}绯荤粺澶囦唤涓庢仮澶?
	  echo -e "${gl_kjlan}35.  ${gl_bai}ssh杩滅▼杩炴帴宸ュ叿                    ${gl_kjlan}36.  ${gl_bai}纭洏鍒嗗尯绠＄悊宸ュ叿"
	  echo -e "${gl_kjlan}37.  ${gl_bai}鍛戒护琛屽巻鍙茶褰?                    ${gl_kjlan}38.  ${gl_bai}rsync杩滅▼鍚屾宸ュ叿"
	  echo -e "${gl_kjlan}39.  ${gl_bai}鍛戒护鏀惰棌澶?${gl_huang}鈽?{gl_bai}                       ${gl_kjlan}40.  ${gl_bai}缃戝崱绠＄悊宸ュ叿"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}41.  ${gl_bai}绯荤粺鏃ュ織绠＄悊宸ュ叿 ${gl_huang}鈽?{gl_bai}                 ${gl_kjlan}42.  ${gl_bai}绯荤粺鍙橀噺绠＄悊宸ュ叿"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}61.  ${gl_bai}鐣欒█鏉?                            ${gl_kjlan}66.  ${gl_bai}涓€鏉￠緳绯荤粺璋冧紭 ${gl_huang}鈽?{gl_bai}"
	  echo -e "${gl_kjlan}99.  ${gl_bai}閲嶅惎鏈嶅姟鍣?                        ${gl_kjlan}100. ${gl_bai}闅愮涓庡畨鍏?
	  echo -e "${gl_kjlan}101. ${gl_bai}k鍛戒护楂樼骇鐢ㄦ硶 ${gl_huang}鈽?{gl_bai}                    ${gl_kjlan}102. ${gl_bai}鍗歌浇绉戞妧lion鑴氭湰"
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}0.   ${gl_bai}杩斿洖涓昏彍鍗?
	  echo -e "${gl_kjlan}------------------------${gl_bai}"
	  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice

	  case $sub_choice in
		  1)
			  while true; do
				  clear
				  read -e -p "璇疯緭鍏ヤ綘鐨勫揩鎹锋寜閿紙杈撳叆0閫€鍑猴級: " kuaijiejian
				  if [ "$kuaijiejian" == "0" ]; then
					   break_end
					   linux_Settings
				  fi
				  find /usr/local/bin/ -type l -exec bash -c 'test "$(readlink -f {})" = "/usr/local/bin/k" && rm -f {}' \;
				  if [ "$kuaijiejian" != "k" ]; then
					  ln -sf /usr/local/bin/k /usr/local/bin/$kuaijiejian
				  fi
				  ln -sf /usr/local/bin/k /usr/bin/$kuaijiejian > /dev/null 2>&1
				  echo "蹇嵎閿凡璁剧疆"
				  send_stats "鑴氭湰蹇嵎閿凡璁剧疆"
				  break_end
				  linux_Settings
			  done
			  ;;

		  2)
			  clear
			  send_stats "璁剧疆浣犵殑鐧诲綍瀵嗙爜"
			  echo "璁剧疆浣犵殑鐧诲綍瀵嗙爜"
			  passwd
			  ;;
		  3)
			  clear
			  add_sshpasswd
			  ;;

		  4)
			root_use
			send_stats "py鐗堟湰绠＄悊"
			echo "python鐗堟湰绠＄悊"
			echo "瑙嗛浠嬬粛: https://www.bilibili.com/video/BV1Pm42157cK?t=0.1"
			echo "---------------------------------------"
			echo "璇ュ姛鑳藉彲鏃犵紳瀹夎python瀹樻柟鏀寔鐨勪换浣曠増鏈紒"
			local VERSION=$(python3 -V 2>&1 | awk '{print $2}')
			echo -e "褰撳墠python鐗堟湰鍙? ${gl_huang}$VERSION${gl_bai}"
			echo "------------"
			echo "鎺ㄨ崘鐗堟湰:  3.12    3.11    3.10    3.9    3.8    2.7"
			echo "鏌ヨ鏇村鐗堟湰: https://www.python.org/downloads/"
			echo "------------"
			read -e -p "杈撳叆浣犺瀹夎鐨刾ython鐗堟湰鍙凤紙杈撳叆0閫€鍑猴級: " py_new_v


			if [[ "$py_new_v" == "0" ]]; then
				send_stats "鑴氭湰PY绠＄悊"
				break_end
				linux_Settings
			fi


			if ! grep -q 'export PYENV_ROOT="\$HOME/.pyenv"' ~/.bashrc; then
				if command -v yum &>/dev/null; then
					yum update -y && yum install git -y
					yum groupinstall "Development Tools" -y
					yum install openssl-devel bzip2-devel libffi-devel ncurses-devel zlib-devel readline-devel sqlite-devel xz-devel findutils -y

					curl -O https://www.openssl.org/source/openssl-1.1.1u.tar.gz
					tar -xzf openssl-1.1.1u.tar.gz
					cd openssl-1.1.1u
					./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl shared zlib
					make
					make install
					echo "/usr/local/openssl/lib" > /etc/ld.so.conf.d/openssl-1.1.1u.conf
					ldconfig -v
					cd ..

					export LDFLAGS="-L/usr/local/openssl/lib"
					export CPPFLAGS="-I/usr/local/openssl/include"
					export PKG_CONFIG_PATH="/usr/local/openssl/lib/pkgconfig"

				elif command -v apt &>/dev/null; then
					apt update -y && apt install git -y
					apt install build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev libgdbm-dev libnss3-dev libedit-dev -y
				elif command -v apk &>/dev/null; then
					apk update && apk add git
					apk add --no-cache bash gcc musl-dev libffi-dev openssl-dev bzip2-dev zlib-dev readline-dev sqlite-dev libc6-compat linux-headers make xz-dev build-base  ncurses-dev
				else
					echo "鏈煡鐨勫寘绠＄悊鍣?"
					return
				fi

				curl https://pyenv.run | bash
				cat << EOF >> ~/.bashrc

export PYENV_ROOT="\$HOME/.pyenv"
if [[ -d "\$PYENV_ROOT/bin" ]]; then
  export PATH="\$PYENV_ROOT/bin:\$PATH"
fi
eval "\$(pyenv init --path)"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"

EOF

			fi

			sleep 1
			source ~/.bashrc
			sleep 1
			pyenv install $py_new_v
			pyenv global $py_new_v

			rm -rf /tmp/python-build.*
			rm -rf $(pyenv root)/cache/*

			local VERSION=$(python -V 2>&1 | awk '{print $2}')
			echo -e "褰撳墠python鐗堟湰鍙? ${gl_huang}$VERSION${gl_bai}"
			send_stats "鑴氭湰PY鐗堟湰鍒囨崲"

			  ;;

		  5)
			  root_use
			  send_stats "寮€鏀剧鍙?
			  iptables_open
			  remove iptables-persistent ufw firewalld iptables-services > /dev/null 2>&1
			  echo "绔彛宸插叏閮ㄥ紑鏀?

			  ;;
		  6)
			root_use
			send_stats "淇敼SSH绔彛"

			while true; do
				clear
				sed -i 's/^\s*#\?\s*Port/Port/' /etc/ssh/sshd_config

				# 璇诲彇褰撳墠鐨?SSH 绔彛鍙?
				local current_port=$(grep -E '^ *Port [0-9]+' /etc/ssh/sshd_config | awk '{print $2}')

				# 鎵撳嵃褰撳墠鐨?SSH 绔彛鍙?
				echo -e "褰撳墠鐨?SSH 绔彛鍙锋槸:  ${gl_huang}$current_port ${gl_bai}"

				echo "------------------------"
				echo "绔彛鍙疯寖鍥?鍒?5535涔嬮棿鐨勬暟瀛椼€傦紙杈撳叆0閫€鍑猴級"

				# 鎻愮ず鐢ㄦ埛杈撳叆鏂扮殑 SSH 绔彛鍙?
				read -e -p "璇疯緭鍏ユ柊鐨?SSH 绔彛鍙? " new_port

				# 鍒ゆ柇绔彛鍙锋槸鍚﹀湪鏈夋晥鑼冨洿鍐?
				if [[ $new_port =~ ^[0-9]+$ ]]; then  # 妫€鏌ヨ緭鍏ユ槸鍚︿负鏁板瓧
					if [[ $new_port -ge 1 && $new_port -le 65535 ]]; then
						send_stats "SSH绔彛宸蹭慨鏀?
						new_ssh_port $new_port
					elif [[ $new_port -eq 0 ]]; then
						send_stats "閫€鍑篠SH绔彛淇敼"
						break
					else
						echo "绔彛鍙锋棤鏁堬紝璇疯緭鍏?鍒?5535涔嬮棿鐨勬暟瀛椼€?
						send_stats "杈撳叆鏃犳晥SSH绔彛"
						break_end
					fi
				else
					echo "杈撳叆鏃犳晥锛岃杈撳叆鏁板瓧銆?
					send_stats "杈撳叆鏃犳晥SSH绔彛"
					break_end
				fi
			done


			  ;;


		  7)
			set_dns_ui
			  ;;

		  8)

			dd_xitong
			  ;;
		  9)
			root_use
			send_stats "鏂扮敤鎴风鐢╮oot"
			read -e -p "璇疯緭鍏ユ柊鐢ㄦ埛鍚嶏紙杈撳叆0閫€鍑猴級: " new_username
			if [ "$new_username" == "0" ]; then
				break_end
				linux_Settings
			fi

			create_user_with_sshkey $new_username true

			ssh-keygen -l -f /home/$new_username/.ssh/authorized_keys &>/dev/null && {
				passwd -l root &>/dev/null
				sed -i 's/^[[:space:]]*#\?[[:space:]]*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
			}

			;;


		  10)
			root_use
			send_stats "璁剧疆v4/v6浼樺厛绾?
			while true; do
				clear
				echo "璁剧疆v4/v6浼樺厛绾?
				echo "------------------------"


				if grep -Eq '^\s*precedence\s+::ffff:0:0/96\s+100\s*$' /etc/gai.conf 2>/dev/null; then
					echo -e "褰撳墠缃戠粶浼樺厛绾ц缃? ${gl_huang}IPv4${gl_bai} 浼樺厛"
				else
					echo -e "褰撳墠缃戠粶浼樺厛绾ц缃? ${gl_huang}IPv6${gl_bai} 浼樺厛"
				fi

				echo ""
				echo "------------------------"
				echo "1. IPv4 浼樺厛          2. IPv6 浼樺厛          3. IPv6 淇宸ュ叿"
				echo "------------------------"
				echo "0. 杩斿洖涓婁竴绾ч€夊崟"
				echo "------------------------"
				read -e -p "閫夋嫨浼樺厛鐨勭綉缁? " choice

				case $choice in
					1)
						prefer_ipv4
						;;
					2)
						rm -f /etc/gai.conf
						echo "宸插垏鎹负 IPv6 浼樺厛"
						send_stats "宸插垏鎹负 IPv6 浼樺厛"
						;;

					3)
						clear
						bash <(curl -L -s jhb.ovh/jb/v6.sh)
						echo "璇ュ姛鑳界敱jhb澶х鎻愪緵锛屾劅璋粬锛?
						send_stats "ipv6淇"
						;;

					*)
						break
						;;

				esac
			done
			;;

		  11)
			clear
			ss -tulnape
			;;

		  12)
			root_use
			send_stats "璁剧疆铏氭嫙鍐呭瓨"
			while true; do
				clear
				echo "璁剧疆铏氭嫙鍐呭瓨"
				local swap_used=$(free -m | awk 'NR==3{print $3}')
				local swap_total=$(free -m | awk 'NR==3{print $2}')
				local swap_info=$(free -m | awk 'NR==3{used=$3; total=$2; if (total == 0) {percentage=0} else {percentage=used*100/total}; printf "%dM/%dM (%d%%)", used, total, percentage}')

				echo -e "褰撳墠铏氭嫙鍐呭瓨: ${gl_huang}$swap_info${gl_bai}"
				echo "------------------------"
				echo "1. 鍒嗛厤1024M         2. 鍒嗛厤2048M         3. 鍒嗛厤4096M         4. 鑷畾涔夊ぇ灏?
				echo "------------------------"
				echo "0. 杩斿洖涓婁竴绾ч€夊崟"
				echo "------------------------"
				read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " choice

				case "$choice" in
				  1)
					send_stats "宸茶缃?G铏氭嫙鍐呭瓨"
					add_swap 1024

					;;
				  2)
					send_stats "宸茶缃?G铏氭嫙鍐呭瓨"
					add_swap 2048

					;;
				  3)
					send_stats "宸茶缃?G铏氭嫙鍐呭瓨"
					add_swap 4096

					;;

				  4)
					read -e -p "璇疯緭鍏ヨ櫄鎷熷唴瀛樺ぇ灏忥紙鍗曚綅M锛? " new_swap
					add_swap "$new_swap"
					send_stats "宸茶缃嚜瀹氫箟铏氭嫙鍐呭瓨"
					;;

				  *)
					break
					;;
				esac
			done
			;;

		  13)
			  while true; do
				root_use
				send_stats "鐢ㄦ埛绠＄悊"
				echo "鐢ㄦ埛鍒楄〃"
				echo "----------------------------------------------------------------------------"
				printf "%-24s %-34s %-20s %-10s\n" "鐢ㄦ埛鍚? "鐢ㄦ埛鏉冮檺" "鐢ㄦ埛缁? "sudo鏉冮檺"
				while IFS=: read -r username _ userid groupid _ _ homedir shell; do
					local groups=$(groups "$username" | cut -d : -f 2)
					local sudo_status
					if sudo -n -lU "$username" 2>/dev/null | grep -q "(ALL) \(NOPASSWD: \)\?ALL"; then
						sudo_status="Yes"
					else
						sudo_status="No"
					fi
					printf "%-20s %-30s %-20s %-10s\n" "$username" "$homedir" "$groups" "$sudo_status"
				done < /etc/passwd


				  echo ""
				  echo "璐︽埛鎿嶄綔"
				  echo "------------------------"
				  echo "1. 鍒涘缓鏅€氱敤鎴?            2. 鍒涘缓楂樼骇鐢ㄦ埛"
				  echo "------------------------"
				  echo "3. 璧嬩簣鏈€楂樻潈闄?            4. 鍙栨秷鏈€楂樻潈闄?
				  echo "------------------------"
				  echo "5. 鍒犻櫎璐﹀彿"
				  echo "------------------------"
				  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
				  echo "------------------------"
				  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice

				  case $sub_choice in
					  1)
					   # 鎻愮ず鐢ㄦ埛杈撳叆鏂扮敤鎴峰悕
					   read -e -p "璇疯緭鍏ユ柊鐢ㄦ埛鍚? " new_username
					   create_user_with_sshkey $new_username false

						  ;;

					  2)
					   # 鎻愮ず鐢ㄦ埛杈撳叆鏂扮敤鎴峰悕
					   read -e -p "璇疯緭鍏ユ柊鐢ㄦ埛鍚? " new_username
					   create_user_with_sshkey $new_username true

						  ;;
					  3)
					   read -e -p "璇疯緭鍏ョ敤鎴峰悕: " username
					   install sudo
					   cat >"/etc/sudoers.d/$username" <<EOF
$username ALL=(ALL) NOPASSWD:ALL
EOF
					  chmod 440 "/etc/sudoers.d/$username"

						  ;;
					  4)
					   read -e -p "璇疯緭鍏ョ敤鎴峰悕: " username
				  	   if [[ -f "/etc/sudoers.d/$username" ]]; then
						   grep -lR "^$username" /etc/sudoers.d/ 2>/dev/null | xargs rm -f
					   fi
					   sed -i "/^$username\s*ALL=(ALL)/d" /etc/sudoers
						  ;;
					  5)
					   read -e -p "璇疯緭鍏ヨ鍒犻櫎鐨勭敤鎴峰悕: " username
					   userdel -r "$username"
						  ;;

					  *)
						  break  # 璺冲嚭寰幆锛岄€€鍑鸿彍鍗?
						  ;;
				  esac

			  done
			  ;;

		  14)
			clear
			send_stats "鐢ㄦ埛淇℃伅鐢熸垚鍣?
			echo "闅忔満鐢ㄦ埛鍚?
			echo "------------------------"
			for i in {1..5}; do
				username="user$(< /dev/urandom tr -dc _a-z0-9 | head -c6)"
				echo "闅忔満鐢ㄦ埛鍚?$i: $username"
			done

			echo ""
			echo "闅忔満濮撳悕"
			echo "------------------------"
			local first_names=("John" "Jane" "Michael" "Emily" "David" "Sophia" "William" "Olivia" "James" "Emma" "Ava" "Liam" "Mia" "Noah" "Isabella")
			local last_names=("Smith" "Johnson" "Brown" "Davis" "Wilson" "Miller" "Jones" "Garcia" "Martinez" "Williams" "Lee" "Gonzalez" "Rodriguez" "Hernandez")

			# 鐢熸垚5涓殢鏈虹敤鎴峰鍚?
			for i in {1..5}; do
				local first_name_index=$((RANDOM % ${#first_names[@]}))
				local last_name_index=$((RANDOM % ${#last_names[@]}))
				local user_name="${first_names[$first_name_index]} ${last_names[$last_name_index]}"
				echo "闅忔満鐢ㄦ埛濮撳悕 $i: $user_name"
			done

			echo ""
			echo "闅忔満UUID"
			echo "------------------------"
			for i in {1..5}; do
				uuid=$(cat /proc/sys/kernel/random/uuid)
				echo "闅忔満UUID $i: $uuid"
			done

			echo ""
			echo "16浣嶉殢鏈哄瘑鐮?
			echo "------------------------"
			for i in {1..5}; do
				local password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16)
				echo "闅忔満瀵嗙爜 $i: $password"
			done

			echo ""
			echo "32浣嶉殢鏈哄瘑鐮?
			echo "------------------------"
			for i in {1..5}; do
				local password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32)
				echo "闅忔満瀵嗙爜 $i: $password"
			done
			echo ""

			  ;;

		  15)
			root_use
			send_stats "鎹㈡椂鍖?
			while true; do
				clear
				echo "绯荤粺鏃堕棿淇℃伅"

				# 鑾峰彇褰撳墠绯荤粺鏃跺尯
				local timezone=$(current_timezone)

				# 鑾峰彇褰撳墠绯荤粺鏃堕棿
				local current_time=$(date +"%Y-%m-%d %H:%M:%S")

				# 鏄剧ず鏃跺尯鍜屾椂闂?
				echo "褰撳墠绯荤粺鏃跺尯锛?timezone"
				echo "褰撳墠绯荤粺鏃堕棿锛?current_time"

				echo ""
				echo "鏃跺尯鍒囨崲"
				echo "------------------------"
				echo "浜氭床"
				echo "1.  涓浗涓婃捣鏃堕棿             2.  涓浗棣欐腐鏃堕棿"
				echo "3.  鏃ユ湰涓滀含鏃堕棿             4.  闊╁浗棣栧皵鏃堕棿"
				echo "5.  鏂板姞鍧℃椂闂?              6.  鍗板害鍔犲皵鍚勭瓟鏃堕棿"
				echo "7.  闃胯仈閰嬭开鎷滄椂闂?          8.  婢冲ぇ鍒╀簹鎮夊凹鏃堕棿"
				echo "9.  娉板浗鏇艰胺鏃堕棿"
				echo "------------------------"
				echo "娆ф床"
				echo "11. 鑻卞浗浼︽暒鏃堕棿             12. 娉曞浗宸撮粠鏃堕棿"
				echo "13. 寰峰浗鏌忔灄鏃堕棿             14. 淇勭綏鏂帿鏂鏃堕棿"
				echo "15. 鑽峰叞灏ょ壒璧栬但鐗规椂闂?      16. 瑗跨彮鐗欓┈寰烽噷鏃堕棿"
				echo "------------------------"
				echo "缇庢床"
				echo "21. 缇庡浗瑗块儴鏃堕棿             22. 缇庡浗涓滈儴鏃堕棿"
				echo "23. 鍔犳嬁澶ф椂闂?              24. 澧ㄨタ鍝ユ椂闂?
				echo "25. 宸磋タ鏃堕棿                 26. 闃挎牴寤锋椂闂?
				echo "------------------------"
				echo "31. UTC鍏ㄧ悆鏍囧噯鏃堕棿"
				echo "------------------------"
				echo "0. 杩斿洖涓婁竴绾ч€夊崟"
				echo "------------------------"
				read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice


				case $sub_choice in
					1) set_timedate Asia/Shanghai ;;
					2) set_timedate Asia/Hong_Kong ;;
					3) set_timedate Asia/Tokyo ;;
					4) set_timedate Asia/Seoul ;;
					5) set_timedate Asia/Singapore ;;
					6) set_timedate Asia/Kolkata ;;
					7) set_timedate Asia/Dubai ;;
					8) set_timedate Australia/Sydney ;;
					9) set_timedate Asia/Bangkok ;;
					11) set_timedate Europe/London ;;
					12) set_timedate Europe/Paris ;;
					13) set_timedate Europe/Berlin ;;
					14) set_timedate Europe/Moscow ;;
					15) set_timedate Europe/Amsterdam ;;
					16) set_timedate Europe/Madrid ;;
					21) set_timedate America/Los_Angeles ;;
					22) set_timedate America/New_York ;;
					23) set_timedate America/Vancouver ;;
					24) set_timedate America/Mexico_City ;;
					25) set_timedate America/Sao_Paulo ;;
					26) set_timedate America/Argentina/Buenos_Aires ;;
					31) set_timedate UTC ;;
					*) break ;;
				esac
			done
			  ;;

		  16)

			bbrv3
			  ;;

		  17)
			  iptables_panel

			  ;;

		  18)
		  root_use
		  send_stats "淇敼涓绘満鍚?

		  while true; do
			  clear
			  local current_hostname=$(uname -n)
			  echo -e "褰撳墠涓绘満鍚? ${gl_huang}$current_hostname${gl_bai}"
			  echo "------------------------"
			  read -e -p "璇疯緭鍏ユ柊鐨勪富鏈哄悕锛堣緭鍏?閫€鍑猴級: " new_hostname
			  if [ -n "$new_hostname" ] && [ "$new_hostname" != "0" ]; then
				  if [ -f /etc/alpine-release ]; then
					  # Alpine
					  echo "$new_hostname" > /etc/hostname
					  hostname "$new_hostname"
				  else
					  # 鍏朵粬绯荤粺锛屽 Debian, Ubuntu, CentOS 绛?
					  hostnamectl set-hostname "$new_hostname"
					  sed -i "s/$current_hostname/$new_hostname/g" /etc/hostname
					  systemctl restart systemd-hostnamed
				  fi

				  if grep -q "127.0.0.1" /etc/hosts; then
					  sed -i "s/127.0.0.1 .*/127.0.0.1       $new_hostname localhost localhost.localdomain/g" /etc/hosts
				  else
					  echo "127.0.0.1       $new_hostname localhost localhost.localdomain" >> /etc/hosts
				  fi

				  if grep -q "^::1" /etc/hosts; then
					  sed -i "s/^::1 .*/::1             $new_hostname localhost localhost.localdomain ipv6-localhost ipv6-loopback/g" /etc/hosts
				  else
					  echo "::1             $new_hostname localhost localhost.localdomain ipv6-localhost ipv6-loopback" >> /etc/hosts
				  fi

				  echo "涓绘満鍚嶅凡鏇存敼涓? $new_hostname"
				  send_stats "涓绘満鍚嶅凡鏇存敼"
				  sleep 1
			  else
				  echo "宸查€€鍑猴紝鏈洿鏀逛富鏈哄悕銆?
				  break
			  fi
		  done
			  ;;

		  19)
		  root_use
		  send_stats "鎹㈢郴缁熸洿鏂版簮"
		  clear
		  echo "閫夋嫨鏇存柊婧愬尯鍩?
		  echo "鎺ュ叆LinuxMirrors鍒囨崲绯荤粺鏇存柊婧?
		  echo "------------------------"
		  echo "1. 涓浗澶ч檰銆愰粯璁ゃ€?         2. 涓浗澶ч檰銆愭暀鑲茬綉銆?         3. 娴峰鍦板尯          4. 鏅鸿兘鍒囨崲鏇存柊婧?
		  echo "------------------------"
		  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
		  echo "------------------------"
		  read -e -p "杈撳叆浣犵殑閫夋嫨: " choice

		  case $choice in
			  1)
				  send_stats "涓浗澶ч檰榛樿婧?
				  bash <(curl -sSL https://linuxmirrors.cn/main.sh)
				  ;;
			  2)
				  send_stats "涓浗澶ч檰鏁欒偛婧?
				  bash <(curl -sSL https://linuxmirrors.cn/main.sh) --edu
				  ;;
			  3)
				  send_stats "娴峰婧?
				  bash <(curl -sSL https://linuxmirrors.cn/main.sh) --abroad
				  ;;
			  4)
				  send_stats "鏅鸿兘鍒囨崲鏇存柊婧?
				  switch_mirror false false
				  ;;

			  *)
				  echo "宸插彇娑?
				  ;;

		  esac

			  ;;

		  20)
		  send_stats "瀹氭椂浠诲姟绠＄悊"
			  while true; do
				  clear
				  check_crontab_installed
				  clear
				  echo "瀹氭椂浠诲姟鍒楄〃"
				  crontab -l
				  echo ""
				  echo "鎿嶄綔"
				  echo "------------------------"
				  echo "1. 娣诲姞瀹氭椂浠诲姟              2. 鍒犻櫎瀹氭椂浠诲姟              3. 缂栬緫瀹氭椂浠诲姟"
				  echo "------------------------"
				  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
				  echo "------------------------"
				  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice

				  case $sub_choice in
					  1)
						  read -e -p "璇疯緭鍏ユ柊浠诲姟鐨勬墽琛屽懡浠? " newquest
						  echo "------------------------"
						  echo "1. 姣忔湀浠诲姟                 2. 姣忓懆浠诲姟"
						  echo "3. 姣忓ぉ浠诲姟                 4. 姣忓皬鏃朵换鍔?
						  echo "------------------------"
						  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " dingshi

						  case $dingshi in
							  1)
								  read -e -p "閫夋嫨姣忔湀鐨勫嚑鍙锋墽琛屼换鍔★紵 (1-30): " day
								  (crontab -l ; echo "0 0 $day * * $newquest") | crontab - > /dev/null 2>&1
								  ;;
							  2)
								  read -e -p "閫夋嫨鍛ㄥ嚑鎵ц浠诲姟锛?(0-6锛?浠ｈ〃鏄熸湡鏃?: " weekday
								  (crontab -l ; echo "0 0 * * $weekday $newquest") | crontab - > /dev/null 2>&1
								  ;;
							  3)
								  read -e -p "閫夋嫨姣忓ぉ鍑犵偣鎵ц浠诲姟锛燂紙灏忔椂锛?-23锛? " hour
								  (crontab -l ; echo "0 $hour * * * $newquest") | crontab - > /dev/null 2>&1
								  ;;
							  4)
								  read -e -p "杈撳叆姣忓皬鏃剁殑绗嚑鍒嗛挓鎵ц浠诲姟锛燂紙鍒嗛挓锛?-60锛? " minute
								  (crontab -l ; echo "$minute * * * * $newquest") | crontab - > /dev/null 2>&1
								  ;;
							  *)
								  break  # 璺冲嚭
								  ;;
						  esac
						  send_stats "娣诲姞瀹氭椂浠诲姟"
						  ;;
					  2)
						  read -e -p "璇疯緭鍏ラ渶瑕佸垹闄や换鍔＄殑鍏抽敭瀛? " kquest
						  crontab -l | grep -v "$kquest" | crontab -
						  send_stats "鍒犻櫎瀹氭椂浠诲姟"
						  ;;
					  3)
						  crontab -e
						  send_stats "缂栬緫瀹氭椂浠诲姟"
						  ;;
					  *)
						  break  # 璺冲嚭寰幆锛岄€€鍑鸿彍鍗?
						  ;;
				  esac
			  done

			  ;;

		  21)
			  root_use
			  send_stats "鏈湴host瑙ｆ瀽"
			  while true; do
				  clear
				  echo "鏈満host瑙ｆ瀽鍒楄〃"
				  echo "濡傛灉浣犲湪杩欓噷娣诲姞瑙ｆ瀽鍖归厤锛屽皢涓嶅啀浣跨敤鍔ㄦ€佽В鏋愪簡"
				  cat /etc/hosts
				  echo ""
				  echo "鎿嶄綔"
				  echo "------------------------"
				  echo "1. 娣诲姞鏂扮殑瑙ｆ瀽              2. 鍒犻櫎瑙ｆ瀽鍦板潃"
				  echo "------------------------"
				  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
				  echo "------------------------"
				  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " host_dns

				  case $host_dns in
					  1)
						  read -e -p "璇疯緭鍏ユ柊鐨勮В鏋愯褰?鏍煎紡: 110.25.5.33 kejilion.pro : " addhost
						  echo "$addhost" >> /etc/hosts
						  send_stats "鏈湴host瑙ｆ瀽鏂板"

						  ;;
					  2)
						  read -e -p "璇疯緭鍏ラ渶瑕佸垹闄ょ殑瑙ｆ瀽鍐呭鍏抽敭瀛? " delhost
						  sed -i "/$delhost/d" /etc/hosts
						  send_stats "鏈湴host瑙ｆ瀽鍒犻櫎"
						  ;;
					  *)
						  break  # 璺冲嚭寰幆锛岄€€鍑鸿彍鍗?
						  ;;
				  esac
			  done
			  ;;

		  22)
			fail2ban_panel
			  ;;


		  23)
			root_use
			send_stats "闄愭祦鍏虫満鍔熻兘"
			while true; do
				clear
				echo "闄愭祦鍏虫満鍔熻兘"
				echo "瑙嗛浠嬬粛: https://www.bilibili.com/video/BV1mC411j7Qd?t=0.1"
				echo "------------------------------------------------"
				echo "褰撳墠娴侀噺浣跨敤鎯呭喌锛岄噸鍚湇鍔″櫒娴侀噺璁＄畻浼氭竻闆讹紒"
				output_status
				echo -e "${gl_kjlan}鎬绘帴鏀? ${gl_bai}$rx"
				echo -e "${gl_kjlan}鎬诲彂閫? ${gl_bai}$tx"

				# 妫€鏌ユ槸鍚﹀瓨鍦?Limiting_Shut_down.sh 鏂囦欢
				if [ -f ~/Limiting_Shut_down.sh ]; then
					# 鑾峰彇 threshold_gb 鐨勫€?
					local rx_threshold_gb=$(grep -oP 'rx_threshold_gb=\K\d+' ~/Limiting_Shut_down.sh)
					local tx_threshold_gb=$(grep -oP 'tx_threshold_gb=\K\d+' ~/Limiting_Shut_down.sh)
					echo -e "${gl_lv}褰撳墠璁剧疆鐨勮繘绔欓檺娴侀槇鍊间负: ${gl_huang}${rx_threshold_gb}${gl_lv}G${gl_bai}"
					echo -e "${gl_lv}褰撳墠璁剧疆鐨勫嚭绔欓檺娴侀槇鍊间负: ${gl_huang}${tx_threshold_gb}${gl_lv}GB${gl_bai}"
				else
					echo -e "${gl_hui}褰撳墠鏈惎鐢ㄩ檺娴佸叧鏈哄姛鑳?{gl_bai}"
				fi

				echo
				echo "------------------------------------------------"
				echo "绯荤粺姣忓垎閽熶細妫€娴嬪疄闄呮祦閲忔槸鍚﹀埌杈鹃槇鍊硷紝鍒拌揪鍚庝細鑷姩鍏抽棴鏈嶅姟鍣紒"
				echo "------------------------"
				echo "1. 寮€鍚檺娴佸叧鏈哄姛鑳?         2. 鍋滅敤闄愭祦鍏虫満鍔熻兘"
				echo "------------------------"
				echo "0. 杩斿洖涓婁竴绾ч€夊崟"
				echo "------------------------"
				read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " Limiting

				case "$Limiting" in
				  1)
					# 杈撳叆鏂扮殑铏氭嫙鍐呭瓨澶у皬
					echo "濡傛灉瀹為檯鏈嶅姟鍣ㄥ氨100G娴侀噺锛屽彲璁剧疆闃堝€间负95G锛屾彁鍓嶅叧鏈猴紝浠ュ厤鍑虹幇娴侀噺璇樊鎴栨孩鍑恒€?
					read -e -p "璇疯緭鍏ヨ繘绔欐祦閲忛槇鍊硷紙鍗曚綅涓篏锛岄粯璁?00G锛? " rx_threshold_gb
					rx_threshold_gb=${rx_threshold_gb:-100}
					read -e -p "璇疯緭鍏ュ嚭绔欐祦閲忛槇鍊硷紙鍗曚綅涓篏锛岄粯璁?00G锛? " tx_threshold_gb
					tx_threshold_gb=${tx_threshold_gb:-100}
					read -e -p "璇疯緭鍏ユ祦閲忛噸缃棩鏈燂紙榛樿姣忔湀1鏃ラ噸缃級: " cz_day
					cz_day=${cz_day:-1}

					cd ~
					curl -Ss -o ~/Limiting_Shut_down.sh ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/Limiting_Shut_down1.sh
					chmod +x ~/Limiting_Shut_down.sh
					sed -i "s/110/$rx_threshold_gb/g" ~/Limiting_Shut_down.sh
					sed -i "s/120/$tx_threshold_gb/g" ~/Limiting_Shut_down.sh
					check_crontab_installed
					crontab -l | grep -v '~/Limiting_Shut_down.sh' | crontab -
					(crontab -l ; echo "* * * * * ~/Limiting_Shut_down.sh") | crontab - > /dev/null 2>&1
					crontab -l | grep -v 'reboot' | crontab -
					(crontab -l ; echo "0 1 $cz_day * * reboot") | crontab - > /dev/null 2>&1
					echo "闄愭祦鍏虫満宸茶缃?
					send_stats "闄愭祦鍏虫満宸茶缃?
					;;
				  2)
					check_crontab_installed
					crontab -l | grep -v '~/Limiting_Shut_down.sh' | crontab -
					crontab -l | grep -v 'reboot' | crontab -
					rm ~/Limiting_Shut_down.sh
					echo "宸插叧闂檺娴佸叧鏈哄姛鑳?
					;;
				  *)
					break
					;;
				esac
			done
			  ;;


		  24)
			sshkey_panel
			  ;;

		  25)
			  root_use
			  send_stats "鐢垫姤棰勮"
			  echo "TG-bot鐩戞帶棰勮鍔熻兘"
			  echo "瑙嗛浠嬬粛: https://youtu.be/vLL-eb3Z_TY"
			  echo "------------------------------------------------"
			  echo "鎮ㄩ渶瑕侀厤缃畉g鏈哄櫒浜篈PI鍜屾帴鏀堕璀︾殑鐢ㄦ埛ID锛屽嵆鍙疄鐜版湰鏈篊PU锛屽唴瀛橈紝纭洏锛屾祦閲忥紝SSH鐧诲綍鐨勫疄鏃剁洃鎺ч璀?
			  echo "鍒拌揪闃堝€煎悗浼氬悜鐢ㄦ埛鍙戦璀︽秷鎭?
			  echo -e "${gl_hui}-鍏充簬娴侀噺锛岄噸鍚湇鍔″櫒灏嗛噸鏂拌绠?${gl_bai}"
			  read -e -p "纭畾缁х画鍚楋紵(Y/N): " choice

			  case "$choice" in
				[Yy])
				  send_stats "鐢垫姤棰勮鍚敤"
				  cd ~
				  install nano tmux bc jq
				  check_crontab_installed
				  if [ -f ~/TG-check-notify.sh ]; then
					  chmod +x ~/TG-check-notify.sh
					  nano ~/TG-check-notify.sh
				  else
					  curl -sS -O ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/TG-check-notify.sh
					  chmod +x ~/TG-check-notify.sh
					  nano ~/TG-check-notify.sh
				  fi
				  tmux kill-session -t TG-check-notify > /dev/null 2>&1
				  tmux new -d -s TG-check-notify "~/TG-check-notify.sh"
				  crontab -l | grep -v '~/TG-check-notify.sh' | crontab - > /dev/null 2>&1
				  (crontab -l ; echo "@reboot tmux new -d -s TG-check-notify '~/TG-check-notify.sh'") | crontab - > /dev/null 2>&1

				  curl -sS -O ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/TG-SSH-check-notify.sh > /dev/null 2>&1
				  sed -i "3i$(grep '^TELEGRAM_BOT_TOKEN=' ~/TG-check-notify.sh)" TG-SSH-check-notify.sh > /dev/null 2>&1
				  sed -i "4i$(grep '^CHAT_ID=' ~/TG-check-notify.sh)" TG-SSH-check-notify.sh
				  chmod +x ~/TG-SSH-check-notify.sh

				  # 娣诲姞鍒?~/.profile 鏂囦欢涓?
				  if ! grep -q 'bash ~/TG-SSH-check-notify.sh' ~/.profile > /dev/null 2>&1; then
					  echo 'bash ~/TG-SSH-check-notify.sh' >> ~/.profile
					  if command -v dnf &>/dev/null || command -v yum &>/dev/null; then
						 echo 'source ~/.profile' >> ~/.bashrc
					  fi
				  fi

				  source ~/.profile

				  clear
				  echo "TG-bot棰勮绯荤粺宸插惎鍔?
				  echo -e "${gl_hui}浣犺繕鍙互灏唕oot鐩綍涓殑TG-check-notify.sh棰勮鏂囦欢鏀惧埌鍏朵粬鏈哄櫒涓婄洿鎺ヤ娇鐢紒${gl_bai}"
				  ;;
				[Nn])
				  echo "宸插彇娑?
				  ;;
				*)
				  echo "鏃犳晥鐨勯€夋嫨锛岃杈撳叆 Y 鎴?N銆?
				  ;;
			  esac
			  ;;

		  26)
			  root_use
			  send_stats "淇SSH楂樺嵄婕忔礊"
			  cd ~
			  curl -sS -O ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/upgrade_openssh9.8p1.sh
			  chmod +x ~/upgrade_openssh9.8p1.sh
			  ~/upgrade_openssh9.8p1.sh
			  rm -f ~/upgrade_openssh9.8p1.sh
			  ;;

		  27)
			  elrepo
			  ;;
		  28)
			  Kernel_optimize
			  ;;

		  29)
			  clamav
			  ;;

		  30)
			  linux_file
			  ;;

		  31)
			  linux_language
			  ;;

		  32)
			  shell_bianse
			  ;;
		  33)
			  linux_trash
			  ;;
		  34)
			  linux_backup
			  ;;
		  35)
			  ssh_manager
			  ;;
		  36)
			  disk_manager
			  ;;
		  37)
			  clear
			  send_stats "鍛戒护琛屽巻鍙茶褰?
			  get_history_file() {
				  for file in "$HOME"/.bash_history "$HOME"/.ash_history "$HOME"/.zsh_history "$HOME"/.local/share/fish/fish_history; do
					  [ -f "$file" ] && { echo "$file"; return; }
				  done
				  return 1
			  }

			  history_file=$(get_history_file) && cat -n "$history_file"
			  ;;

		  38)
			  rsync_manager
			  ;;


		  39)
			  clear
			  linux_fav
			  ;;

		  40)
			  clear
			  net_menu
			  ;;

		  41)
			  clear
			  log_menu
			  ;;

		  42)
			  clear
			  env_menu
			  ;;


		  61)
			clear
			send_stats "鐣欒█鏉?
			echo "璁块棶绉戞妧lion瀹樻柟鐣欒█鏉匡紝鎮ㄥ鑴氭湰鏈変换浣曟兂娉曟杩庣暀瑷€浜ゆ祦锛?
			echo "https://board.kejilion.pro"
			echo "鍏叡瀵嗙爜: kejilion.sh"
			  ;;

		  66)

			  root_use
			  send_stats "涓€鏉￠緳璋冧紭"
			  echo "涓€鏉￠緳绯荤粺璋冧紭"
			  echo "------------------------------------------------"
			  echo "灏嗗浠ヤ笅鍐呭杩涜鎿嶄綔涓庝紭鍖?
			  echo "1. 浼樺寲绯荤粺鏇存柊婧愶紝鏇存柊绯荤粺鍒版渶鏂?
			  echo "2. 娓呯悊绯荤粺鍨冨溇鏂囦欢"
			  echo -e "3. 璁剧疆铏氭嫙鍐呭瓨${gl_huang}1G${gl_bai}"
			  echo -e "4. 璁剧疆SSH绔彛鍙蜂负${gl_huang}5522${gl_bai}"
			  echo -e "5. 鍚姩fail2ban闃插尽SSH鏆村姏鐮磋В"
			  echo -e "6. 寮€鏀炬墍鏈夌鍙?
			  echo -e "7. 寮€鍚?{gl_huang}BBR${gl_bai}鍔犻€?
			  echo -e "8. 璁剧疆鏃跺尯鍒?{gl_huang}涓婃捣${gl_bai}"
			  echo -e "9. 鑷姩浼樺寲DNS鍦板潃${gl_huang}娴峰: 1.1.1.1 8.8.8.8  鍥藉唴: 223.5.5.5 ${gl_bai}"
		  	  echo -e "10. 璁剧疆缃戠粶涓?{gl_huang}ipv4浼樺厛${gl_bai}"
			  echo -e "11. 瀹夎鍩虹宸ュ叿${gl_huang}docker wget sudo tar unzip socat btop nano vim${gl_bai}"
			  echo -e "12. Linux绯荤粺鍐呮牳鍙傛暟浼樺寲鍒囨崲鍒?{gl_huang}鍧囪　浼樺寲妯″紡${gl_bai}"
			  echo "------------------------------------------------"
			  read -e -p "纭畾涓€閿繚鍏诲悧锛?Y/N): " choice

			  case "$choice" in
				[Yy])
				  clear
				  send_stats "涓€鏉￠緳璋冧紭鍚姩"
				  echo "------------------------------------------------"
				  switch_mirror false false
				  linux_update
				  echo -e "[${gl_lv}OK${gl_bai}] 1/12. 鏇存柊绯荤粺鍒版渶鏂?

				  echo "------------------------------------------------"
				  linux_clean
				  echo -e "[${gl_lv}OK${gl_bai}] 2/12. 娓呯悊绯荤粺鍨冨溇鏂囦欢"

				  echo "------------------------------------------------"
				  add_swap 1024
				  echo -e "[${gl_lv}OK${gl_bai}] 3/12. 璁剧疆铏氭嫙鍐呭瓨${gl_huang}1G${gl_bai}"

				  echo "------------------------------------------------"
				  new_ssh_port 5522
				  echo -e "[${gl_lv}OK${gl_bai}] 4/12. 璁剧疆SSH绔彛鍙蜂负${gl_huang}5522${gl_bai}"
				  echo "------------------------------------------------"
				  f2b_install_sshd
				  cd ~
				  f2b_status
				  echo -e "[${gl_lv}OK${gl_bai}] 5/12. 鍚姩fail2ban闃插尽SSH鏆村姏鐮磋В"

				  echo "------------------------------------------------"
				  echo -e "[${gl_lv}OK${gl_bai}] 6/12. 寮€鏀炬墍鏈夌鍙?

				  echo "------------------------------------------------"
				  bbr_on
				  echo -e "[${gl_lv}OK${gl_bai}] 7/12. 寮€鍚?{gl_huang}BBR${gl_bai}鍔犻€?

				  echo "------------------------------------------------"
				  set_timedate Asia/Shanghai
				  echo -e "[${gl_lv}OK${gl_bai}] 8/12. 璁剧疆鏃跺尯鍒?{gl_huang}涓婃捣${gl_bai}"

				  echo "------------------------------------------------"
				  auto_optimize_dns
				  echo -e "[${gl_lv}OK${gl_bai}] 9/12. 鑷姩浼樺寲DNS鍦板潃${gl_huang}${gl_bai}"
				  echo "------------------------------------------------"
				  prefer_ipv4
				  echo -e "[${gl_lv}OK${gl_bai}] 10/12. 璁剧疆缃戠粶涓?{gl_huang}ipv4浼樺厛${gl_bai}}"

				  echo "------------------------------------------------"
				  install_docker
				  install wget sudo tar unzip socat btop nano vim
				  echo -e "[${gl_lv}OK${gl_bai}] 11/12. 瀹夎鍩虹宸ュ叿${gl_huang}docker wget sudo tar unzip socat btop nano vim${gl_bai}"
				  echo "------------------------------------------------"

				  optimize_balanced
				  echo -e "[${gl_lv}OK${gl_bai}] 12/12. Linux绯荤粺鍐呮牳鍙傛暟浼樺寲"
				  echo -e "${gl_lv}涓€鏉￠緳绯荤粺璋冧紭宸插畬鎴?{gl_bai}"

				  ;;
				[Nn])
				  echo "宸插彇娑?
				  ;;
				*)
				  echo "鏃犳晥鐨勯€夋嫨锛岃杈撳叆 Y 鎴?N銆?
				  ;;
			  esac

			  ;;

		  99)
			  clear
			  send_stats "閲嶅惎绯荤粺"
			  server_reboot
			  ;;
		  100)

			root_use
			while true; do
			  clear
			  if grep -q '^ENABLE_STATS="true"' /usr/local/bin/k > /dev/null 2>&1; then
			  	local status_message="${gl_lv}姝ｅ湪閲囬泦鏁版嵁${gl_bai}"
			  elif grep -q '^ENABLE_STATS="false"' /usr/local/bin/k > /dev/null 2>&1; then
			  	local status_message="${gl_hui}閲囬泦宸插叧闂?{gl_bai}"
			  else
			  	local status_message="鏃犳硶纭畾鐨勭姸鎬?
			  fi

			  echo "闅愮涓庡畨鍏?
			  echo "鑴氭湰灏嗘敹闆嗙敤鎴蜂娇鐢ㄥ姛鑳界殑鏁版嵁锛屼紭鍖栬剼鏈綋楠岋紝鍒朵綔鏇村濂界帺濂界敤鐨勫姛鑳?
			  echo "灏嗘敹闆嗚剼鏈増鏈彿锛屼娇鐢ㄧ殑鏃堕棿锛岀郴缁熺増鏈紝CPU鏋舵瀯锛屾満鍣ㄦ墍灞炲浗瀹跺拰浣跨敤鐨勫姛鑳界殑鍚嶇О锛?
			  echo "------------------------------------------------"
			  echo -e "褰撳墠鐘舵€? $status_message"
			  echo "--------------------"
			  echo "1. 寮€鍚噰闆?
			  echo "2. 鍏抽棴閲囬泦"
			  echo "--------------------"
			  echo "0. 杩斿洖涓婁竴绾ч€夊崟"
			  echo "--------------------"
			  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice
			  case $sub_choice in
				  1)
					  cd ~
					  sed -i 's/^ENABLE_STATS="false"/ENABLE_STATS="true"/' /usr/local/bin/k
					  sed -i 's/^ENABLE_STATS="false"/ENABLE_STATS="true"/' ~/kejilion.sh
					  echo "宸插紑鍚噰闆?
					  send_stats "闅愮涓庡畨鍏ㄥ凡寮€鍚噰闆?
					  ;;
				  2)
					  cd ~
					  sed -i 's/^ENABLE_STATS="true"/ENABLE_STATS="false"/' /usr/local/bin/k
					  sed -i 's/^ENABLE_STATS="true"/ENABLE_STATS="false"/' ~/kejilion.sh
					  echo "宸插叧闂噰闆?
					  send_stats "闅愮涓庡畨鍏ㄥ凡鍏抽棴閲囬泦"
					  ;;
				  *)
					  break
					  ;;
			  esac
			done
			  ;;

		  101)
			  clear
			  k_info
			  ;;

		  102)
			  clear
			  send_stats "鍗歌浇绉戞妧lion鑴氭湰"
			  echo "鍗歌浇绉戞妧lion鑴氭湰"
			  echo "------------------------------------------------"
			  echo "灏嗗交搴曞嵏杞絢ejilion鑴氭湰锛屼笉褰卞搷浣犲叾浠栧姛鑳?
			  read -e -p "纭畾缁х画鍚楋紵(Y/N): " choice

			  case "$choice" in
				[Yy])
				  clear
				  (crontab -l | grep -v "kejilion.sh") | crontab -
				  rm -f /usr/local/bin/k
				  rm ~/kejilion.sh
				  echo "鑴氭湰宸插嵏杞斤紝鍐嶈锛?
				  break_end
				  clear
				  exit
				  ;;
				[Nn])
				  echo "宸插彇娑?
				  ;;
				*)
				  echo "鏃犳晥鐨勯€夋嫨锛岃杈撳叆 Y 鎴?N銆?
				  ;;
			  esac
			  ;;

		  0)
			  kejilion

			  ;;
		  *)
			  echo "鏃犳晥鐨勮緭鍏?"
			  ;;
	  esac
	  break_end

	done



}






linux_file() {
	root_use
	send_stats "鏂囦欢绠＄悊鍣?
	while true; do
		clear
		echo "鏂囦欢绠＄悊鍣?
		echo "------------------------"
		echo "褰撳墠璺緞"
		pwd
		echo "------------------------"
		ls --color=auto -x
		echo "------------------------"
		echo "1.  杩涘叆鐩綍           2.  鍒涘缓鐩綍             3.  淇敼鐩綍鏉冮檺         4.  閲嶅懡鍚嶇洰褰?
		echo "5.  鍒犻櫎鐩綍           6.  杩斿洖涓婁竴绾ч€夊崟鐩綍"
		echo "------------------------"
		echo "11. 鍒涘缓鏂囦欢           12. 缂栬緫鏂囦欢             13. 淇敼鏂囦欢鏉冮檺         14. 閲嶅懡鍚嶆枃浠?
		echo "15. 鍒犻櫎鏂囦欢"
		echo "------------------------"
		echo "21. 鍘嬬缉鏂囦欢鐩綍       22. 瑙ｅ帇鏂囦欢鐩綍         23. 绉诲姩鏂囦欢鐩綍         24. 澶嶅埗鏂囦欢鐩綍"
		echo "25. 浼犳枃浠惰嚦鍏朵粬鏈嶅姟鍣?
		echo "------------------------"
		echo "0.  杩斿洖涓婁竴绾ч€夊崟"
		echo "------------------------"
		read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " Limiting

		case "$Limiting" in
			1)  # 杩涘叆鐩綍
				read -e -p "璇疯緭鍏ョ洰褰曞悕: " dirname
				cd "$dirname" 2>/dev/null || echo "鏃犳硶杩涘叆鐩綍"
				send_stats "杩涘叆鐩綍"
				;;
			2)  # 鍒涘缓鐩綍
				read -e -p "璇疯緭鍏ヨ鍒涘缓鐨勭洰褰曞悕: " dirname
				mkdir -p "$dirname" && echo "鐩綍宸插垱寤? || echo "鍒涘缓澶辫触"
				send_stats "鍒涘缓鐩綍"
				;;
			3)  # 淇敼鐩綍鏉冮檺
				read -e -p "璇疯緭鍏ョ洰褰曞悕: " dirname
				read -e -p "璇疯緭鍏ユ潈闄?(濡?755): " perm
				chmod "$perm" "$dirname" && echo "鏉冮檺宸蹭慨鏀? || echo "淇敼澶辫触"
				send_stats "淇敼鐩綍鏉冮檺"
				;;
			4)  # 閲嶅懡鍚嶇洰褰?
				read -e -p "璇疯緭鍏ュ綋鍓嶇洰褰曞悕: " current_name
				read -e -p "璇疯緭鍏ユ柊鐩綍鍚? " new_name
				mv "$current_name" "$new_name" && echo "鐩綍宸查噸鍛藉悕" || echo "閲嶅懡鍚嶅け璐?
				send_stats "閲嶅懡鍚嶇洰褰?
				;;
			5)  # 鍒犻櫎鐩綍
				read -e -p "璇疯緭鍏ヨ鍒犻櫎鐨勭洰褰曞悕: " dirname
				rm -rf "$dirname" && echo "鐩綍宸插垹闄? || echo "鍒犻櫎澶辫触"
				send_stats "鍒犻櫎鐩綍"
				;;
			6)  # 杩斿洖涓婁竴绾ч€夊崟鐩綍
				cd ..
				send_stats "杩斿洖涓婁竴绾ч€夊崟鐩綍"
				;;
			11) # 鍒涘缓鏂囦欢
				read -e -p "璇疯緭鍏ヨ鍒涘缓鐨勬枃浠跺悕: " filename
				touch "$filename" && echo "鏂囦欢宸插垱寤? || echo "鍒涘缓澶辫触"
				send_stats "鍒涘缓鏂囦欢"
				;;
			12) # 缂栬緫鏂囦欢
				read -e -p "璇疯緭鍏ヨ缂栬緫鐨勬枃浠跺悕: " filename
				install nano
				nano "$filename"
				send_stats "缂栬緫鏂囦欢"
				;;
			13) # 淇敼鏂囦欢鏉冮檺
				read -e -p "璇疯緭鍏ユ枃浠跺悕: " filename
				read -e -p "璇疯緭鍏ユ潈闄?(濡?755): " perm
				chmod "$perm" "$filename" && echo "鏉冮檺宸蹭慨鏀? || echo "淇敼澶辫触"
				send_stats "淇敼鏂囦欢鏉冮檺"
				;;
			14) # 閲嶅懡鍚嶆枃浠?
				read -e -p "璇疯緭鍏ュ綋鍓嶆枃浠跺悕: " current_name
				read -e -p "璇疯緭鍏ユ柊鏂囦欢鍚? " new_name
				mv "$current_name" "$new_name" && echo "鏂囦欢宸查噸鍛藉悕" || echo "閲嶅懡鍚嶅け璐?
				send_stats "閲嶅懡鍚嶆枃浠?
				;;
			15) # 鍒犻櫎鏂囦欢
				read -e -p "璇疯緭鍏ヨ鍒犻櫎鐨勬枃浠跺悕: " filename
				rm -f "$filename" && echo "鏂囦欢宸插垹闄? || echo "鍒犻櫎澶辫触"
				send_stats "鍒犻櫎鏂囦欢"
				;;
			21) # 鍘嬬缉鏂囦欢/鐩綍
				read -e -p "璇疯緭鍏ヨ鍘嬬缉鐨勬枃浠?鐩綍鍚? " name
				install tar
				tar -czvf "$name.tar.gz" "$name" && echo "宸插帇缂╀负 $name.tar.gz" || echo "鍘嬬缉澶辫触"
				send_stats "鍘嬬缉鏂囦欢/鐩綍"
				;;
			22) # 瑙ｅ帇鏂囦欢/鐩綍
				read -e -p "璇疯緭鍏ヨ瑙ｅ帇鐨勬枃浠跺悕 (.tar.gz): " filename
				install tar
				tar -xzvf "$filename" && echo "宸茶В鍘?$filename" || echo "瑙ｅ帇澶辫触"
				send_stats "瑙ｅ帇鏂囦欢/鐩綍"
				;;

			23) # 绉诲姩鏂囦欢鎴栫洰褰?
				read -e -p "璇疯緭鍏ヨ绉诲姩鐨勬枃浠舵垨鐩綍璺緞: " src_path
				if [ ! -e "$src_path" ]; then
					echo "閿欒: 鏂囦欢鎴栫洰褰曚笉瀛樺湪銆?
					send_stats "绉诲姩鏂囦欢鎴栫洰褰曞け璐? 鏂囦欢鎴栫洰褰曚笉瀛樺湪"
					continue
				fi

				read -e -p "璇疯緭鍏ョ洰鏍囪矾寰?(鍖呮嫭鏂版枃浠跺悕鎴栫洰褰曞悕): " dest_path
				if [ -z "$dest_path" ]; then
					echo "閿欒: 璇疯緭鍏ョ洰鏍囪矾寰勩€?
					send_stats "绉诲姩鏂囦欢鎴栫洰褰曞け璐? 鐩爣璺緞鏈寚瀹?
					continue
				fi

				mv "$src_path" "$dest_path" && echo "鏂囦欢鎴栫洰褰曞凡绉诲姩鍒?$dest_path" || echo "绉诲姩鏂囦欢鎴栫洰褰曞け璐?
				send_stats "绉诲姩鏂囦欢鎴栫洰褰?
				;;


		   24) # 澶嶅埗鏂囦欢鐩綍
				read -e -p "璇疯緭鍏ヨ澶嶅埗鐨勬枃浠舵垨鐩綍璺緞: " src_path
				if [ ! -e "$src_path" ]; then
					echo "閿欒: 鏂囦欢鎴栫洰褰曚笉瀛樺湪銆?
					send_stats "澶嶅埗鏂囦欢鎴栫洰褰曞け璐? 鏂囦欢鎴栫洰褰曚笉瀛樺湪"
					continue
				fi

				read -e -p "璇疯緭鍏ョ洰鏍囪矾寰?(鍖呮嫭鏂版枃浠跺悕鎴栫洰褰曞悕): " dest_path
				if [ -z "$dest_path" ]; then
					echo "閿欒: 璇疯緭鍏ョ洰鏍囪矾寰勩€?
					send_stats "澶嶅埗鏂囦欢鎴栫洰褰曞け璐? 鐩爣璺緞鏈寚瀹?
					continue
				fi

				# 浣跨敤 -r 閫夐」浠ラ€掑綊鏂瑰紡澶嶅埗鐩綍
				cp -r "$src_path" "$dest_path" && echo "鏂囦欢鎴栫洰褰曞凡澶嶅埗鍒?$dest_path" || echo "澶嶅埗鏂囦欢鎴栫洰褰曞け璐?
				send_stats "澶嶅埗鏂囦欢鎴栫洰褰?
				;;


			 25) # 浼犻€佹枃浠惰嚦杩滅鏈嶅姟鍣?
				read -e -p "璇疯緭鍏ヨ浼犻€佺殑鏂囦欢璺緞: " file_to_transfer
				if [ ! -f "$file_to_transfer" ]; then
					echo "閿欒: 鏂囦欢涓嶅瓨鍦ㄣ€?
					send_stats "浼犻€佹枃浠跺け璐? 鏂囦欢涓嶅瓨鍦?
					continue
				fi

				read -e -p "璇疯緭鍏ヨ繙绔湇鍔″櫒IP: " remote_ip
				if [ -z "$remote_ip" ]; then
					echo "閿欒: 璇疯緭鍏ヨ繙绔湇鍔″櫒IP銆?
					send_stats "浼犻€佹枃浠跺け璐? 鏈緭鍏ヨ繙绔湇鍔″櫒IP"
					continue
				fi

				read -e -p "璇疯緭鍏ヨ繙绔湇鍔″櫒鐢ㄦ埛鍚?(榛樿root): " remote_user
				remote_user=${remote_user:-root}

				read -e -p "璇疯緭鍏ヨ繙绔湇鍔″櫒瀵嗙爜: " -s remote_password
				echo
				if [ -z "$remote_password" ]; then
					echo "閿欒: 璇疯緭鍏ヨ繙绔湇鍔″櫒瀵嗙爜銆?
					send_stats "浼犻€佹枃浠跺け璐? 鏈緭鍏ヨ繙绔湇鍔″櫒瀵嗙爜"
					continue
				fi

				read -e -p "璇疯緭鍏ョ櫥褰曠鍙?(榛樿22): " remote_port
				remote_port=${remote_port:-22}

				# 娓呴櫎宸茬煡涓绘満鐨勬棫鏉＄洰
				ssh-keygen -f "/root/.ssh/known_hosts" -R "$remote_ip"
				sleep 2  # 绛夊緟鏃堕棿

				# 浣跨敤scp浼犺緭鏂囦欢
				scp -P "$remote_port" -o StrictHostKeyChecking=no "$file_to_transfer" "$remote_user@$remote_ip:/home/" <<EOF
$remote_password
EOF

				if [ $? -eq 0 ]; then
					echo "鏂囦欢宸蹭紶閫佽嚦杩滅▼鏈嶅姟鍣╤ome鐩綍銆?
					send_stats "鏂囦欢浼犻€佹垚鍔?
				else
					echo "鏂囦欢浼犻€佸け璐ャ€?
					send_stats "鏂囦欢浼犻€佸け璐?
				fi

				break_end
				;;



			0)  # 杩斿洖涓婁竴绾ч€夊崟
				send_stats "杩斿洖涓婁竴绾ч€夊崟鑿滃崟"
				break
				;;
			*)  # 澶勭悊鏃犳晥杈撳叆
				echo "鏃犳晥鐨勯€夋嫨锛岃閲嶆柊杈撳叆"
				send_stats "鏃犳晥閫夋嫨"
				;;
		esac
	done
}






cluster_python3() {
	install python3 python3-paramiko
	cd ~/cluster/
	curl -sS -O ${gh_proxy}raw.githubusercontent.com/kejilion/python-for-vps/main/cluster/$py_task
	python3 ~/cluster/$py_task
}


run_commands_on_servers() {

	install sshpass

	local SERVERS_FILE="$HOME/cluster/servers.py"
	local SERVERS=$(grep -oP '{"name": "\K[^"]+|"hostname": "\K[^"]+|"port": \K[^,]+|"username": "\K[^"]+|"password": "\K[^"]+' "$SERVERS_FILE")

	# 灏嗘彁鍙栫殑淇℃伅杞崲涓烘暟缁?
	IFS=$'\n' read -r -d '' -a SERVER_ARRAY <<< "$SERVERS"

	# 閬嶅巻鏈嶅姟鍣ㄥ苟鎵ц鍛戒护
	for ((i=0; i<${#SERVER_ARRAY[@]}; i+=5)); do
		local name=${SERVER_ARRAY[i]}
		local hostname=${SERVER_ARRAY[i+1]}
		local port=${SERVER_ARRAY[i+2]}
		local username=${SERVER_ARRAY[i+3]}
		local password=${SERVER_ARRAY[i+4]}
		echo
		echo -e "${gl_huang}杩炴帴鍒?$name ($hostname)...${gl_bai}"
		# sshpass -p "$password" ssh -o StrictHostKeyChecking=no "$username@$hostname" -p "$port" "$1"
		sshpass -p "$password" ssh -t -o StrictHostKeyChecking=no "$username@$hostname" -p "$port" "$1"
	done
	echo
	break_end

}


linux_cluster() {
mkdir cluster
if [ ! -f ~/cluster/servers.py ]; then
	cat > ~/cluster/servers.py << EOF
servers = [

]
EOF
fi

while true; do
	  clear
	  send_stats "闆嗙兢鎺у埗涓績"
	  echo "鏈嶅姟鍣ㄩ泦缇ゆ帶鍒?
	  cat ~/cluster/servers.py
	  echo
	  echo -e "${gl_kjlan}------------------------${gl_bai}"
	  echo -e "${gl_kjlan}鏈嶅姟鍣ㄥ垪琛ㄧ鐞?{gl_bai}"
	  echo -e "${gl_kjlan}1.  ${gl_bai}娣诲姞鏈嶅姟鍣?              ${gl_kjlan}2.  ${gl_bai}鍒犻櫎鏈嶅姟鍣?           ${gl_kjlan}3.  ${gl_bai}缂栬緫鏈嶅姟鍣?
	  echo -e "${gl_kjlan}4.  ${gl_bai}澶囦唤闆嗙兢                 ${gl_kjlan}5.  ${gl_bai}杩樺師闆嗙兢"
	  echo -e "${gl_kjlan}------------------------${gl_bai}"
	  echo -e "${gl_kjlan}鎵归噺鎵ц浠诲姟${gl_bai}"
	  echo -e "${gl_kjlan}11. ${gl_bai}瀹夎绉戞妧lion鑴氭湰         ${gl_kjlan}12. ${gl_bai}鏇存柊绯荤粺              ${gl_kjlan}13. ${gl_bai}娓呯悊绯荤粺"
	  echo -e "${gl_kjlan}14. ${gl_bai}瀹夎docker               ${gl_kjlan}15. ${gl_bai}瀹夎BBR3              ${gl_kjlan}16. ${gl_bai}璁剧疆1G铏氭嫙鍐呭瓨"
	  echo -e "${gl_kjlan}17. ${gl_bai}璁剧疆鏃跺尯鍒颁笂娴?          ${gl_kjlan}18. ${gl_bai}寮€鏀炬墍鏈夌鍙?       ${gl_kjlan}51. ${gl_bai}鑷畾涔夋寚浠?
	  echo -e "${gl_kjlan}------------------------${gl_bai}"
	  echo -e "${gl_kjlan}0.  ${gl_bai}杩斿洖涓昏彍鍗?
	  echo -e "${gl_kjlan}------------------------${gl_bai}"
	  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice

	  case $sub_choice in
		  1)
			  send_stats "娣诲姞闆嗙兢鏈嶅姟鍣?
			  read -e -p "鏈嶅姟鍣ㄥ悕绉? " server_name
			  read -e -p "鏈嶅姟鍣↖P: " server_ip
			  read -e -p "鏈嶅姟鍣ㄧ鍙ｏ紙22锛? " server_port
			  local server_port=${server_port:-22}
			  read -e -p "鏈嶅姟鍣ㄧ敤鎴峰悕锛坮oot锛? " server_username
			  local server_username=${server_username:-root}
			  read -e -p "鏈嶅姟鍣ㄧ敤鎴峰瘑鐮? " server_password

			  sed -i "/servers = \[/a\    {\"name\": \"$server_name\", \"hostname\": \"$server_ip\", \"port\": $server_port, \"username\": \"$server_username\", \"password\": \"$server_password\", \"remote_path\": \"/home/\"}," ~/cluster/servers.py

			  ;;
		  2)
			  send_stats "鍒犻櫎闆嗙兢鏈嶅姟鍣?
			  read -e -p "璇疯緭鍏ラ渶瑕佸垹闄ょ殑鍏抽敭瀛? " rmserver
			  sed -i "/$rmserver/d" ~/cluster/servers.py
			  ;;
		  3)
			  send_stats "缂栬緫闆嗙兢鏈嶅姟鍣?
			  install nano
			  nano ~/cluster/servers.py
			  ;;

		  4)
			  clear
			  send_stats "澶囦唤闆嗙兢"
			  echo -e "璇峰皢 ${gl_huang}/root/cluster/servers.py${gl_bai} 鏂囦欢涓嬭浇锛屽畬鎴愬浠斤紒"
			  break_end
			  ;;

		  5)
			  clear
			  send_stats "杩樺師闆嗙兢"
			  echo "璇蜂笂浼犳偍鐨剆ervers.py锛屾寜浠绘剰閿紑濮嬩笂浼狅紒"
			  echo -e "璇蜂笂浼犳偍鐨?${gl_huang}servers.py${gl_bai} 鏂囦欢鍒?${gl_huang}/root/cluster/${gl_bai} 瀹屾垚杩樺師锛?
			  break_end
			  ;;

		  11)
			  local py_task="install_kejilion.py"
			  cluster_python3
			  ;;
		  12)
			  run_commands_on_servers "k update"
			  ;;
		  13)
			  run_commands_on_servers "k clean"
			  ;;
		  14)
			  run_commands_on_servers "k docker install"
			  ;;
		  15)
			  run_commands_on_servers "k bbr3"
			  ;;
		  16)
			  run_commands_on_servers "k swap 1024"
			  ;;
		  17)
			  run_commands_on_servers "k time Asia/Shanghai"
			  ;;
		  18)
			  run_commands_on_servers "k iptables_open"
			  ;;

		  51)
			  send_stats "鑷畾涔夋墽琛屽懡浠?
			  read -e -p "璇疯緭鍏ユ壒閲忔墽琛岀殑鍛戒护: " mingling
			  run_commands_on_servers "${mingling}"
			  ;;

		  *)
			  kejilion
			  ;;
	  esac
done

}




kejilion_Affiliates() {

clear
send_stats "骞垮憡涓撴爮"
echo "骞垮憡涓撴爮"
echo "------------------------"
echo "灏嗕负鐢ㄦ埛鎻愪緵鏇寸畝鍗曚紭闆呯殑鎺ㄥ箍涓庤喘涔颁綋楠岋紒"
echo ""
echo -e "鏈嶅姟鍣ㄤ紭鎯?
echo "------------------------"
echo -e "${gl_lan}鑾卞崱浜?棣欐腐CN2 GIA 闊╁浗鍙孖SP 缇庡浗CN2 GIA 浼樻儬娲诲姩${gl_bai}"
echo -e "${gl_bai}缃戝潃: https://www.lcayun.com/aff/ZEXUQBIM${gl_bai}"
echo "------------------------"
echo -e "${gl_lan}RackNerd 10.99鍒€姣忓勾 缇庡浗 1鏍稿績 1G鍐呭瓨 20G纭洏 1T娴侀噺姣忔湀${gl_bai}"
echo -e "${gl_bai}缃戝潃: https://my.racknerd.com/aff.php?aff=5501&pid=879${gl_bai}"
echo "------------------------"
echo -e "${gl_zi}Hostinger 52.7鍒€姣忓勾 缇庡浗 1鏍稿績 4G鍐呭瓨 50G纭洏 4T娴侀噺姣忔湀${gl_bai}"
echo -e "${gl_bai}缃戝潃: https://cart.hostinger.com/pay/d83c51e9-0c28-47a6-8414-b8ab010ef94f?_ga=GA1.3.942352702.1711283207${gl_bai}"
echo "------------------------"
echo -e "${gl_huang}鎼摝宸?49鍒€姣忓 缇庡浗CN2GIA 鏃ユ湰杞摱 2鏍稿績 1G鍐呭瓨 20G纭洏 1T娴侀噺姣忔湀${gl_bai}"
echo -e "${gl_bai}缃戝潃: https://bandwagonhost.com/aff.php?aff=69004&pid=87${gl_bai}"
echo "------------------------"
echo -e "${gl_lan}DMIT 28鍒€姣忓 缇庡浗CN2GIA 1鏍稿績 2G鍐呭瓨 20G纭洏 800G娴侀噺姣忔湀${gl_bai}"
echo -e "${gl_bai}缃戝潃: https://www.dmit.io/aff.php?aff=4966&pid=100${gl_bai}"
echo "------------------------"
echo -e "${gl_zi}V.PS 6.9鍒€姣忔湀 涓滀含杞摱 2鏍稿績 1G鍐呭瓨 20G纭洏 1T娴侀噺姣忔湀${gl_bai}"
echo -e "${gl_bai}缃戝潃: https://vps.hosting/cart/tokyo-cloud-kvm-vps/?id=148&?affid=1355&?affid=1355${gl_bai}"
echo "------------------------"
echo -e "${gl_kjlan}VPS鏇村鐑棬浼樻儬${gl_bai}"
echo -e "${gl_bai}缃戝潃: https://kejilion.pro/topvps/${gl_bai}"
echo "------------------------"
echo ""
echo -e "鍩熷悕浼樻儬"
echo "------------------------"
echo -e "${gl_lan}GNAME 8.8鍒€棣栧勾COM鍩熷悕 6.68鍒€棣栧勾CC鍩熷悕${gl_bai}"
echo -e "${gl_bai}缃戝潃: https://www.gname.com/register?tt=86836&ttcode=KEJILION86836&ttbj=sh${gl_bai}"
echo "------------------------"
echo ""
echo -e "绉戞妧lion鍛ㄨ竟"
echo "------------------------"
echo -e "${gl_kjlan}B绔? ${gl_bai}https://b23.tv/2mqnQyh              ${gl_kjlan}娌圭: ${gl_bai}https://www.youtube.com/@kejilion${gl_bai}"
echo -e "${gl_kjlan}瀹樼綉: ${gl_bai}https://kejilion.pro/              ${gl_kjlan}瀵艰埅: ${gl_bai}https://dh.kejilion.pro/${gl_bai}"
echo -e "${gl_kjlan}鍗氬: ${gl_bai}https://blog.kejilion.pro/         ${gl_kjlan}杞欢涓績: ${gl_bai}https://app.kejilion.pro/${gl_bai}"
echo "------------------------"
echo -e "${gl_kjlan}鑴氭湰瀹樼綉: ${gl_bai}https://kejilion.sh            ${gl_kjlan}GitHub鍦板潃: ${gl_bai}${gh_https_url}github.com/kejilion/sh${gl_bai}"
echo "------------------------"
echo ""
}




games_server_tools() {

	while true; do
	  clear
	  echo -e "娓告垙寮€鏈嶈剼鏈悎闆?
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}1. ${gl_bai}骞诲吔甯曢瞾寮€鏈嶈剼鏈?
	  echo -e "${gl_kjlan}2. ${gl_bai}鎴戠殑涓栫晫寮€鏈嶈剼鏈?
	  echo -e "${gl_kjlan}------------------------"
	  echo -e "${gl_kjlan}0. ${gl_bai}杩斿洖涓昏彍鍗?
	  echo -e "${gl_kjlan}------------------------${gl_bai}"
	  read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " sub_choice

	  case $sub_choice in

		  1) send_stats "骞诲吔甯曢瞾寮€鏈嶈剼鏈? ; cd ~
			 curl -sS -O ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/palworld.sh ; chmod +x palworld.sh ; ./palworld.sh
			 exit
			 ;;
		  2) send_stats "鎴戠殑涓栫晫寮€鏈嶈剼鏈? ; cd ~
			 curl -sS -O ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/mc.sh ; chmod +x mc.sh ; ./mc.sh
			 exit
			 ;;

		  0)
			kejilion
			;;

		  *)
			echo "鏃犳晥鐨勮緭鍏?"
			;;
	  esac
	  break_end

	done


}





















kejilion_update() {

send_stats "鑴氭湰鏇存柊"
cd ~
while true; do
	clear
	echo "鏇存柊鏃ュ織"
	echo "------------------------"
	echo "鍏ㄩ儴鏃ュ織: ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/kejilion_sh_log.txt"
	echo "------------------------"

	curl -s ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/kejilion_sh_log.txt | tail -n 30
	local sh_v_new=$(curl -s ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/kejilion.sh | grep -o 'sh_v="[0-9.]*"' | cut -d '"' -f 2)

	if [ "$sh_v" = "$sh_v_new" ]; then
		echo -e "${gl_lv}浣犲凡缁忔槸鏈€鏂扮増鏈紒${gl_huang}v$sh_v${gl_bai}"
		send_stats "鑴氭湰宸茬粡鏈€鏂颁簡锛屾棤闇€鏇存柊"
	else
		echo "鍙戠幇鏂扮増鏈紒"
		echo -e "褰撳墠鐗堟湰 v$sh_v        鏈€鏂扮増鏈?${gl_huang}v$sh_v_new${gl_bai}"
	fi


	local cron_job="kejilion.sh"
	local existing_cron=$(crontab -l 2>/dev/null | grep -F "$cron_job")

	if [ -n "$existing_cron" ]; then
		echo "------------------------"
		echo -e "${gl_lv}鑷姩鏇存柊宸插紑鍚紝姣忓ぉ鍑屾櫒2鐐硅剼鏈細鑷姩鏇存柊锛?{gl_bai}"
	fi

	echo "------------------------"
	echo "1. 鐜板湪鏇存柊            2. 寮€鍚嚜鍔ㄦ洿鏂?           3. 鍏抽棴鑷姩鏇存柊"
	echo "------------------------"
	echo "0. 杩斿洖涓昏彍鍗?
	echo "------------------------"
	read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " choice
	case "$choice" in
		1)
			clear
			local country=$(curl -s ipinfo.io/country)
			if [ "$country" = "CN" ]; then
				curl -sS -O ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/cn/kejilion.sh && chmod +x kejilion.sh
			else
				curl -sS -O ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/kejilion.sh && chmod +x kejilion.sh
			fi
			canshu_v6
			CheckFirstRun_true
			yinsiyuanquan2
			cp -f ~/kejilion.sh /usr/local/bin/k > /dev/null 2>&1
			echo -e "${gl_lv}鑴氭湰宸叉洿鏂板埌鏈€鏂扮増鏈紒${gl_huang}v$sh_v_new${gl_bai}"
			send_stats "鑴氭湰宸茬粡鏈€鏂?sh_v_new"
			break_end
			~/kejilion.sh
			exit
			;;
		2)
			clear
			local country=$(curl -s ipinfo.io/country)
			local ipv6_address=$(curl -s --max-time 1 ipv6.ip.sb)
			if [ "$country" = "CN" ]; then
				SH_Update_task="curl -sS -O https://gh.kejilion.pro/raw.githubusercontent.com/kejilion/sh/main/kejilion.sh && chmod +x kejilion.sh && sed -i 's/canshu=\"default\"/canshu=\"CN\"/g' ./kejilion.sh"
			elif [ -n "$ipv6_address" ]; then
				SH_Update_task="curl -sS -O https://gh.kejilion.pro/raw.githubusercontent.com/kejilion/sh/main/kejilion.sh && chmod +x kejilion.sh && sed -i 's/canshu=\"default\"/canshu=\"V6\"/g' ./kejilion.sh"
			else
				SH_Update_task="curl -sS -O https://raw.githubusercontent.com/kejilion/sh/main/kejilion.sh && chmod +x kejilion.sh"
			fi
			check_crontab_installed
			(crontab -l | grep -v "kejilion.sh") | crontab -
			# (crontab -l 2>/dev/null; echo "0 2 * * * bash -c \"$SH_Update_task\"") | crontab -
			(crontab -l 2>/dev/null; echo "$(shuf -i 0-59 -n 1) 2 * * * bash -c \"$SH_Update_task\"") | crontab -
			echo -e "${gl_lv}鑷姩鏇存柊宸插紑鍚紝姣忓ぉ鍑屾櫒2鐐硅剼鏈細鑷姩鏇存柊锛?{gl_bai}"
			send_stats "寮€鍚剼鏈嚜鍔ㄦ洿鏂?
			break_end
			;;
		3)
			clear
			(crontab -l | grep -v "kejilion.sh") | crontab -
			echo -e "${gl_lv}鑷姩鏇存柊宸插叧闂?{gl_bai}"
			send_stats "鍏抽棴鑴氭湰鑷姩鏇存柊"
			break_end
			;;
		*)
			kejilion_sh
			;;
	esac
done

}





kejilion_sh() {
while true; do
clear
echo -e "${gl_kjlan}"
echo "鈺︹晹鈺愨晹鈺愨晽 鈺︹暒鈺? 鈺︹晹鈺愨晽鈺斺晽鈺?鈺斺晲鈺椻暒 鈺?
echo "鈺犫暕鈺椻晳鈺? 鈺戔晳鈺? 鈺戔晳 鈺戔晳鈺戔晳 鈺氣晲鈺椻暊鈺愨暎"
echo "鈺?鈺┾暁鈺愨暆鈺氣暆鈺┾暕鈺愨暆鈺┾暁鈺愨暆鈺濃暁鈺漮鈺氣晲鈺濃暕 鈺?
echo -e "绉戞妧lion鑴氭湰宸ュ叿绠?v$sh_v"
echo -e "鍛戒护琛岃緭鍏?{gl_huang}k${gl_kjlan}鍙揩閫熷惎鍔ㄨ剼鏈?{gl_bai}"
echo -e "${gl_kjlan}------------------------${gl_bai}"
echo -e "${gl_kjlan}1.   ${gl_bai}绯荤粺淇℃伅鏌ヨ"
echo -e "${gl_kjlan}2.   ${gl_bai}绯荤粺鏇存柊"
echo -e "${gl_kjlan}3.   ${gl_bai}绯荤粺娓呯悊"
echo -e "${gl_kjlan}4.   ${gl_bai}鍩虹宸ュ叿"
echo -e "${gl_kjlan}5.   ${gl_bai}BBR绠＄悊"
echo -e "${gl_kjlan}6.   ${gl_bai}Docker绠＄悊"
echo -e "${gl_kjlan}7.   ${gl_bai}WARP绠＄悊"
echo -e "${gl_kjlan}8.   ${gl_bai}娴嬭瘯鑴氭湰鍚堥泦"
echo -e "${gl_kjlan}9.   ${gl_bai}鐢查鏂囦簯鑴氭湰鍚堥泦"
echo -e "${gl_huang}10.  ${gl_bai}LDNMP寤虹珯"
echo -e "${gl_kjlan}11.  ${gl_bai}搴旂敤甯傚満"
echo -e "${gl_kjlan}12.  ${gl_bai}鍚庡彴宸ヤ綔鍖?
echo -e "${gl_kjlan}13.  ${gl_bai}绯荤粺宸ュ叿"
echo -e "${gl_kjlan}14.  ${gl_bai}鏈嶅姟鍣ㄩ泦缇ゆ帶鍒?
echo -e "${gl_kjlan}15.  ${gl_bai}骞垮憡涓撴爮"
echo -e "${gl_kjlan}16.  ${gl_bai}娓告垙寮€鏈嶈剼鏈悎闆?
echo -e "${gl_kjlan}------------------------${gl_bai}"
echo -e "${gl_kjlan}00.  ${gl_bai}鑴氭湰鏇存柊"
echo -e "${gl_kjlan}------------------------${gl_bai}"
echo -e "${gl_kjlan}0.   ${gl_bai}閫€鍑鸿剼鏈?
echo -e "${gl_kjlan}------------------------${gl_bai}"
read -e -p "璇疯緭鍏ヤ綘鐨勯€夋嫨: " choice

case $choice in
  1) linux_info ;;
  2) clear ; send_stats "绯荤粺鏇存柊" ; linux_update ;;
  3) clear ; send_stats "绯荤粺娓呯悊" ; linux_clean ;;
  4) linux_tools ;;
  5) linux_bbr ;;
  6) linux_docker ;;
  7) clear ; send_stats "warp绠＄悊" ; install wget
	wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh ; bash menu.sh [option] [lisence/url/token]
	;;
  8) linux_test ;;
  9) linux_Oracle ;;
  10) linux_ldnmp ;;
  11) linux_panel ;;
  12) linux_work ;;
  13) linux_Settings ;;
  14) linux_cluster ;;
  15) kejilion_Affiliates ;;
  16) games_server_tools ;;
  00) kejilion_update ;;
  0) clear ; exit ;;
  *) echo "鏃犳晥鐨勮緭鍏?" ;;
esac
	break_end
done
}


k_info() {
send_stats "k鍛戒护鍙傝€冪敤渚?
echo "-------------------"
echo "瑙嗛浠嬬粛: https://www.bilibili.com/video/BV1ib421E7it?t=0.1"
echo "浠ヤ笅鏄痥鍛戒护鍙傝€冪敤渚嬶細"
echo "鍚姩鑴氭湰            k"
echo "瀹夎杞欢鍖?         k install nano wget | k add nano wget | k 瀹夎 nano wget"
echo "鍗歌浇杞欢鍖?         k remove nano wget | k del nano wget | k uninstall nano wget | k 鍗歌浇 nano wget"
echo "鏇存柊绯荤粺            k update | k 鏇存柊"
echo "娓呯悊绯荤粺鍨冨溇        k clean | k 娓呯悊"
echo "閲嶈绯荤粺闈㈡澘        k dd | k 閲嶈"
echo "bbr3鎺у埗闈㈡澘        k bbr3 | k bbrv3"
echo "鍐呮牳璋冧紭闈㈡澘        k nhyh | k 鍐呮牳浼樺寲"
echo "璁剧疆铏氭嫙鍐呭瓨        k swap 2048"
echo "璁剧疆铏氭嫙鏃跺尯        k time Asia/Shanghai | k 鏃跺尯 Asia/Shanghai"
echo "绯荤粺鍥炴敹绔?         k trash | k hsz | k 鍥炴敹绔?
echo "绯荤粺澶囦唤鍔熻兘        k backup | k bf | k 澶囦唤"
echo "ssh杩滅▼杩炴帴宸ュ叿     k ssh | k 杩滅▼杩炴帴"
echo "rsync杩滅▼鍚屾宸ュ叿   k rsync | k 杩滅▼鍚屾"
echo "纭洏绠＄悊宸ュ叿        k disk | k 纭洏绠＄悊"
echo "鍐呯綉绌块€忥紙鏈嶅姟绔級  k frps"
echo "鍐呯綉绌块€忥紙瀹㈡埛绔級  k frpc"
echo "杞欢鍚姩            k start sshd | k 鍚姩 sshd "
echo "杞欢鍋滄            k stop sshd | k 鍋滄 sshd "
echo "杞欢閲嶅惎            k restart sshd | k 閲嶅惎 sshd "
echo "杞欢鐘舵€佹煡鐪?       k status sshd | k 鐘舵€?sshd "
echo "杞欢寮€鏈哄惎鍔?       k enable docker | k autostart docke | k 寮€鏈哄惎鍔?docker "
echo "鍩熷悕璇佷功鐢宠        k ssl"
echo "鍩熷悕璇佷功鍒版湡鏌ヨ    k ssl ps"
echo "docker绠＄悊骞抽潰      k docker"
echo "docker鐜瀹夎      k docker install |k docker 瀹夎"
echo "docker瀹瑰櫒绠＄悊      k docker ps |k docker 瀹瑰櫒"
echo "docker闀滃儚绠＄悊      k docker img |k docker 闀滃儚"
echo "LDNMP绔欑偣绠＄悊       k web"
echo "LDNMP缂撳瓨娓呯悊       k web cache"
echo "瀹夎WordPress       k wp |k wordpress |k wp xxx.com"
echo "瀹夎鍙嶅悜浠ｇ悊        k fd |k rp |k 鍙嶄唬 |k fd xxx.com"
echo "瀹夎璐熻浇鍧囪　        k loadbalance |k 璐熻浇鍧囪　"
echo "瀹夎L4璐熻浇鍧囪　      k stream |k L4璐熻浇鍧囪　"
echo "闃茬伀澧欓潰鏉?         k fhq |k 闃茬伀澧?
echo "寮€鏀剧鍙?           k dkdk 8080 |k 鎵撳紑绔彛 8080"
echo "鍏抽棴绔彛            k gbdk 7800 |k 鍏抽棴绔彛 7800"
echo "鏀捐IP              k fxip 127.0.0.0/8 |k 鏀捐IP 127.0.0.0/8"
echo "闃绘IP              k zzip 177.5.25.36 |k 闃绘IP 177.5.25.36"
echo "鍛戒护鏀惰棌澶?         k fav | k 鍛戒护鏀惰棌澶?
echo "搴旂敤甯傚満绠＄悊        k app"
echo "搴旂敤缂栧彿蹇嵎绠＄悊    k app 26 | k app 1panel | k app npm"
echo "fail2ban绠＄悊        k fail2ban | k f2b"
echo "鏄剧ず绯荤粺淇℃伅        k info"
echo "ROOT瀵嗛挜绠＄悊        k sshkey"
echo "SSH鍏挜瀵煎叆(URL)    k sshkey <url>"
echo "SSH鍏挜瀵煎叆(GitHub) k sshkey github <user> "

}



if [ "$#" -eq 0 ]; then
	# 濡傛灉娌℃湁鍙傛暟锛岃繍琛屼氦浜掑紡閫昏緫
	kejilion_sh
else
	# 濡傛灉鏈夊弬鏁帮紝鎵ц鐩稿簲鍑芥暟
	case $1 in
		install|add|瀹夎)
			shift
			send_stats "瀹夎杞欢"
			install "$@"
			;;
		remove|del|uninstall|鍗歌浇)
			shift
			send_stats "鍗歌浇杞欢"
			remove "$@"
			;;
		update|鏇存柊)
			linux_update
			;;
		clean|娓呯悊)
			linux_clean
			;;
		dd|閲嶈)
			dd_xitong
			;;
		bbr3|bbrv3)
			bbrv3
			;;
		nhyh|鍐呮牳浼樺寲)
			Kernel_optimize
			;;
		trash|hsz|鍥炴敹绔?
			linux_trash
			;;
		backup|bf|澶囦唤)
			linux_backup
			;;
		ssh|杩滅▼杩炴帴)
			ssh_manager
			;;

		rsync|杩滅▼鍚屾)
			rsync_manager
			;;

		rsync_run)
			shift
			send_stats "瀹氭椂rsync鍚屾"
			run_task "$@"
			;;

		disk|纭洏绠＄悊)
			disk_manager
			;;

		wp|wordpress)
			shift
			ldnmp_wp "$@"

			;;
		fd|rp|鍙嶄唬)
			shift
			ldnmp_Proxy "$@"
	  		find_container_by_host_port "$port"
	  		if [ -z "$docker_name" ]; then
	  		  close_port "$port"
			  echo "宸查樆姝P+绔彛璁块棶璇ユ湇鍔?
	  		else
			  ip_address
			  close_port "$port"
	  		  block_container_port "$docker_name" "$ipv4_address"
	  		fi
			;;

		loadbalance|璐熻浇鍧囪　)
			ldnmp_Proxy_backend
			;;


		stream|L4璐熻浇鍧囪　)
			ldnmp_Proxy_backend_stream
			;;

		swap)
			shift
			send_stats "蹇€熻缃櫄鎷熷唴瀛?
			add_swap "$@"
			;;

		time|鏃跺尯)
			shift
			send_stats "蹇€熻缃椂鍖?
			set_timedate "$@"
			;;


		iptables_open)
			iptables_open
			;;

		frps)
			frps_panel
			;;

		frpc)
			frpc_panel
			;;


		鎵撳紑绔彛|dkdk)
			shift
			open_port "$@"
			;;

		鍏抽棴绔彛|gbdk)
			shift
			close_port "$@"
			;;

		鏀捐IP|fxip)
			shift
			allow_ip "$@"
			;;

		闃绘IP|zzip)
			shift
			block_ip "$@"
			;;

		闃茬伀澧檤fhq)
			iptables_panel
			;;

		鍛戒护鏀惰棌澶箌fav)
			linux_fav
			;;

		status|鐘舵€?
			shift
			send_stats "杞欢鐘舵€佹煡鐪?
			status "$@"
			;;
		start|鍚姩)
			shift
			send_stats "杞欢鍚姩"
			start "$@"
			;;
		stop|鍋滄)
			shift
			send_stats "杞欢鏆傚仠"
			stop "$@"
			;;
		restart|閲嶅惎)
			shift
			send_stats "杞欢閲嶅惎"
			restart "$@"
			;;

		enable|autostart|寮€鏈哄惎鍔?
			shift
			send_stats "杞欢寮€鏈鸿嚜鍚?
			enable "$@"
			;;

		ssl)
			shift
			if [ "$1" = "ps" ]; then
				send_stats "鏌ョ湅璇佷功鐘舵€?
				ssl_ps
			elif [ -z "$1" ]; then
				add_ssl
				send_stats "蹇€熺敵璇疯瘉涔?
			elif [ -n "$1" ]; then
				add_ssl "$1"
				send_stats "蹇€熺敵璇疯瘉涔?
			else
				k_info
			fi
			;;

		docker)
			shift
			case $1 in
				install|瀹夎)
					send_stats "蹇嵎瀹夎docker"
					install_docker
					;;
				ps|瀹瑰櫒)
					send_stats "蹇嵎瀹瑰櫒绠＄悊"
					docker_ps
					;;
				img|闀滃儚)
					send_stats "蹇嵎闀滃儚绠＄悊"
					docker_image
					;;
				*)
					linux_docker
					;;
			esac
			;;

		web)
		   shift
			if [ "$1" = "cache" ]; then
				web_cache
			elif [ "$1" = "sec" ]; then
				web_security
			elif [ "$1" = "opt" ]; then
				web_optimization
			elif [ -z "$1" ]; then
				ldnmp_web_status
			else
				k_info
			fi
			;;


		app)
			shift
			send_stats "搴旂敤$@"
			linux_panel "$@"
			;;


		info)
			linux_info
			;;

		fail2ban|f2b)
			fail2ban_panel
			;;


		sshkey)

			shift
			case "$1" in
				"" )
					# sshkey 鈫?浜や簰鑿滃崟
					send_stats "SSHKey 浜や簰鑿滃崟"
					sshkey_panel
					;;
				github )
					shift
					send_stats "浠?GitHub 瀵煎叆 SSH 鍏挜"
					fetch_github_ssh_keys "$1"
					;;
				http://*|https://* )
					send_stats "浠?URL 瀵煎叆 SSH 鍏挜"
					fetch_remote_ssh_keys "$1"
					;;
				ssh-rsa*|ssh-ed25519*|ssh-ecdsa* )
					send_stats "鍏挜鐩存帴瀵煎叆"
					import_sshkey "$1"
					;;
				* )
					echo "閿欒锛氭湭鐭ュ弬鏁?'$1'"
					echo "鐢ㄦ硶锛?
					echo "  k sshkey                  杩涘叆浜や簰鑿滃崟"
					echo "  k sshkey \"<pubkey>\"     鐩存帴瀵煎叆 SSH 鍏挜"
					echo "  k sshkey <url>            浠?URL 瀵煎叆 SSH 鍏挜"
					echo "  k sshkey github <user>    浠?GitHub 瀵煎叆 SSH 鍏挜"
					;;
			esac

			;;
		*)
			k_info
			;;
	esac
fi
