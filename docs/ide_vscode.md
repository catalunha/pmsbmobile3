# Dicas

# Snippets

~~~json
"Print to console": {
    "prefix": "print",
    "body": [
        "print('>>> $1 <<< ${$1}');"
    ],
    "description": "Log output to console"
},
"Field toMap": {
    "prefix": "ftomap",
    "body": [
        "data['$1'] = this.$1;"
    ],
    "description": "Log output to console"
},
"class toMap": {
    "prefix": "ctomap",
    "body": [
        "Map<String, dynamic> toMap() {",
            "final Map<String, dynamic> data = new Map<String, dynamic>();",
                "$0",
            "return data;",
          "}",
    ],
    "description": "Log output to console"
}

~~~