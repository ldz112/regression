## {{ model.name }}

> {{ "函数" if model.showkey else "请求地址" }}

```text
{{ model.key if model.showkey else model.url }}
```

{{ model.md }}

{% if model.hasInput %}
> 输入参数

|名称|类型|默认值|示例值|描述|
|----|----|----|----|----|
{% for p in model.input %}|{{p.name or ""}}|{{p.type or ""}}|{{p.dv or ""}}|{{p.example or ""}}|{{p.remark or ""}}|
{% endfor %}

{% endif %}

{% if model.hasOutput %}
> 输出参数

|名称|类型|示例值|描述|
|----|----|----|----|
{% for p in model.output %}|{{p.name or ""}}|{{p.type or ""}}|{{p.example or ""}}|{{p.remark or ""}}|
{% endfor %}

{% endif %}

{% if model.hasTest %}
> 测试用例

{% for t in model.tests %}
* {{t.name}}

{{t.remark}}

```json
{{ t.json }}
```

<form action="{{t.url}}" method="post" target="_blank" style="margin-top: -1.2em; border-top: 1px solid #eee; padding: 5px; padding-left: 2em; background-color:#f8f8f8;">
<input type="hidden" name="a" value="{{t.a}}" />
<input type="hidden" name="i" value='{{t.i}}' />
<input type="submit" value="Submit" />
</form>

{% endfor %}

{% endif %}