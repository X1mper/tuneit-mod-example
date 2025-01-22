#!/usr/bin/bash

YAML_FILE="module.yaml"
POT_FILE="./po/module.pot"

add_message() {
    local msg="$1"
    if [[ -n "$msg" ]]; then
        echo "msgid \"$msg\"" >> "$POT_FILE"
        echo "msgstr \"\"" >> "$POT_FILE"
        echo "" >> "$POT_FILE"
    fi
}

# Создание или очистка POT файла
> "$POT_FILE"


# Добавление заголовка в POT файл
add_header() {
    {
        echo "#: $YAML_FILE"
        echo "msgid \"\""
        echo "msgstr \"\""
        echo "\"Project-Id-Version: My Project 1.0\\n\""
        echo "\"Report-Msgid-Bugs-To: bugs@example.com\\n\""
        echo "\"POT-Creation-Date: $(date -Ru)\\n\""
        echo "\"PO-Revision-Date: $(date -Ru)\\n\""
        echo "\"Last-Translator: Your Name <yourname@example.com>\\n\""
        echo "\"Language-Team: Russian <ru@example.com>\\n\""
        echo "\"MIME-Version: 1.0\\n\""
        echo "\"Content-Type: text/plain; charset=UTF-8\\n\""
        echo "\"Content-Transfer-Encoding: 8bit\\n\""
        echo "\"X-Generator: Custom Script\\n\""
    } > "$POT_FILE"
}

add_header

matches=$(grep -oP '_[^:]*' "$YAML_FILE")

if [[ -z "$matches" ]]; then
    echo "Не найдено строк с символом '_'."
else
    echo "Найдено строки с символом '_':"
    echo "$matches"
fi

while IFS= read -r line; do
    key=$(echo "$line" | sed 's/^_//; s/"$//')

    if [[ -n "$key" ]]; then
        echo "Добавляем в POT: $key"
        
        add_message "$key"
    fi
done <<< "$matches"

echo "Генерация POT файла завершена. Результат сохранен в '$POT_FILE'."
