engine=$(ibus engine)

ENGLISH="xkb:us::eng"
CHINESE="pinyin"

if [[ "$engine" == "$ENGLISH" ]]; then
    echo "EN"
else
    echo "CN"
fi