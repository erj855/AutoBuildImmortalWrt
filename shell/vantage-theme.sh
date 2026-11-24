#!/bin/sh
# ============================================================
# Vantage 主题注入脚本
# 由 custom-packages.sh / apk-custom-packages.sh 在构建初期 source。
# 项目: https://github.com/anothaDev/luci-theme-vantage
#
# 用法:
#   . shell/vantage-theme.sh apk    # 25.12，下载 .apk
#   . shell/vantage-theme.sh ipk    # 24.10，下载 .ipk
#
# 追新: 只改下面 VANTAGE_TAG 和 VANTAGE_VER 两个变量。
# ============================================================

VANTAGE_TAG="v1.2.0"
VANTAGE_VER="1.2.0-r1"
VANTAGE_BASE="https://github.com/anothaDev/luci-theme-vantage/releases/download/${VANTAGE_TAG}"
VANTAGE_FMT="${1:-apk}"

# 主题 + 实时仪表盘 + 简体中文语言包
VANTAGE_PKGS="luci-theme-vantage luci-app-vantage luci-i18n-vantage-zh-cn luci-i18n-vantage-theme-zh-cn"

# 下载到 extra-packages/vantage/：随后 apk-prepare-packages.sh /
# prepare-packages.sh 会把该子目录里的包收进 ImageBuilder 的 packages/ 并建索引。
mkdir -p extra-packages/vantage
for _vp in $VANTAGE_PKGS; do
  if [ "$VANTAGE_FMT" = "apk" ]; then
    _vf="${_vp}-${VANTAGE_VER}.apk"
  else
    _vf="${_vp}_${VANTAGE_VER}_all.ipk"
  fi
  echo "[Vantage] 下载 $_vf"
  wget -q -O "extra-packages/vantage/$_vf" "$VANTAGE_BASE/$_vf"
  if [ ! -s "extra-packages/vantage/$_vf" ]; then
    echo "[Vantage] 错误：下载失败 $_vf"
    exit 1
  fi
done

CUSTOM_PACKAGES="$CUSTOM_PACKAGES $VANTAGE_PKGS"
echo "[Vantage] 已加入构建: $VANTAGE_PKGS"
