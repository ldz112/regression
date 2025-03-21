> 请求结构

* 采用POST请求。

* Content-Type为application/json。

> 请求头：Headers

|名称|示例值|描述|
|----|----|----|
|X-DD-AK|18cce6dc-47e0-4569-a003-5932c9151e56|一个 ak 对应唯一的 sk ，而 sk 会用来生成请求签名 Token。|
|X-DD-HMAC|sha2|签名方式，可用sha2, sha1, md5。|
|X-DD-Timestamp|1529223702|当前 UNIX 时间戳，可记录发起 API 请求的时间。如果与当前时间相差超过5分钟，会引起签名过期错误。|
|X-DD-Nonce|005355|随机正整数，与 Timestamp 联合起来，用于防止重放攻击。|
|X-DD-Token||请求签名，用来验证此次请求的合法性，需要用户根据实际的输入参数计算得出。|

> 请求体：Body

为JSON格式，如：

```json
{ "a": "baidu.ocr.general_basic", "i": { "url": "https://ocr-demo-1254418846.cos.ap-guangzhou.myqcloud.com/general/AdvertiseOCR/AdvertiseOCR1.jpg" } }
```

* **a** 为Action，表示需要调用的方法键值。
* **i** 为Input，表示需要调用方法的参数。

!> 启用加密传输：一些关键敏感信息，为了提高安全性，可用AES算法对Body进行加密，其密钥为sk的md5值。因加密后的Body不是JSON格式，RPC服务器接收到请求后会自动使用AES解密为JSON。

> 签名计算

待签名数据为请求头除**X-DD-Token**外按字典序排列，后附加请求体：

```text
X-DD-AK:18cce6dc-47e0-4569-a003-5932c9151e56
X-DD-HMAC:sha2
X-DD-Nonce:005355
X-DD-Timestamp:1529223702
{ "a": "baidu.ocr.general_basic", "i": { "url": "https://ocr-demo-1254418846.cos.ap-guangzhou.myqcloud.com/general/AdvertiseOCR/AdvertiseOCR1.jpg" } }
```

假设sk为

```text
fb6a7c60-6e78-4b52-82da-363fd3d2f636
```

则签名结果为

```text
dee4a3a41d38fb9cad7e19a17cefc9fe7901f3dd287e1bcd8088341236fc3180
```

将签名结果放到请求头中，得到请求结构示例：

```text
POST /www/dd/rpc/index
Content-Type: application/json
X-DD-AK:18cce6dc-47e0-4569-a003-5932c9151e56
X-DD-HMAC:sha2
X-DD-Nonce:005355
X-DD-Timestamp:1529223702
X-DD-Token:dee4a3a41d38fb9cad7e19a17cefc9fe7901f3dd287e1bcd8088341236fc3180

{ "a": "baidu.ocr.general_basic", "i": { "url": "https://ocr-demo-1254418846.cos.ap-guangzhou.myqcloud.com/general/AdvertiseOCR/AdvertiseOCR1.jpg" } }
```

按上述约定，集成代码示例为：

```python
ajax({ "url": "http://{host}/www/dd/rpc/index", "headers": headers, "data": body }
```

注：

* 将host替换为真实的服务器地址。
* headers为字典（dict, dynamic），必须包含X-DD-AK，X-DD-HMAC，X-DD-Nonce，X-DD-Timestamp，X-DD-Token各键值。
* 服务器检测body是否为JSON串，如果不是JSON串将进行AES解密。

> 测试示例

* 单次调用

输入：

```json
{ "a": "baidu.ocr.general_basic", "i": { "url": "https://ocr-demo-1254418846.cos.ap-guangzhou.myqcloud.com/general/AdvertiseOCR/AdvertiseOCR1.jpg" } }
```

输出：

```json
{
  "words_result": [
    { "words": "永菥容颜" },
    { "words": "CHERISH THE ACHIEVEMENTS OF LUXURY" },
    { "words": "源于·自然的恩惠" },
    { "words": "化妆品荣誉产品全场7折起售" },
    { "words": "r" }
  ],
  "words_result_num": 5,
  "log_id": 1496353289103455398
}
```

* 批量调用同一接口

输入：

```json
{
    "a": "baidu.ocr.general_basic",
    "i": [
        { "url": "https://ocr-demo-1254418846.cos.ap-guangzhou.myqcloud.com/general/AdvertiseOCR/AdvertiseOCR2.jpg" },
        { "url": "https://ocr-demo-1254418846.cos.ap-guangzhou.myqcloud.com/general/AdvertiseOCR/AdvertiseOCR2.jpg" }
    ]
}
```

输出：

```json
[
  {
    "words_result": [
      { "words": "D白雪" }, { "words": "睡前歌" }, { "words": "睡不着的时候" }, { "words": "我来陪你听歌" }, { "words": "音乐电台" }
    ],
    "words_result_num": 5,
    "log_id": 1496354046595812553
  },
  {
    "words_result": [
      { "words": "D白雪" }, { "words": "睡前歌" }, { "words": "睡不着的时候" }, { "words": "我来陪你听歌" }, { "words": "音乐电台" }
    ],
    "words_result_num": 5,
    "log_id": 1496354051533268641
  }
]
```

* 批量调用多个接口

输入：

```json
[
    { "a": "baidu.ocr.general_basic", "i": { "url": "https://ocr-demo-1254418846.cos.ap-guangzhou.myqcloud.com/general/AdvertiseOCR/AdvertiseOCR2.jpg" } },
    { "a": "baidu.ocr.general_basic", "i": { "url": "https://ocr-demo-1254418846.cos.ap-guangzhou.myqcloud.com/general/AdvertiseOCR/AdvertiseOCR2.jpg" } }
]
```

输出：

```json
[
  {
    "words_result": [
      { "words": "D白雪" }, { "words": "睡前歌" }, { "words": "睡不着的时候" }, { "words": "我来陪你听歌" }, { "words": "音乐电台" }
    ],
    "words_result_num": 5,
    "log_id": 1496354046595812553
  },
  {
    "words_result": [
      { "words": "D白雪" }, { "words": "睡前歌" }, { "words": "睡不着的时候" }, { "words": "我来陪你听歌" }, { "words": "音乐电台" }
    ],
    "words_result_num": 5,
    "log_id": 1496354051533268641
  }
]
```

> 应用授权

进入如下页面，创建APP，进行远程访问授权。

```text
/core/uform/datagrid/dd_rpc_app
```

配置完成后，应用即可调用目标服务器的函数：

```python
ph.dd.rpc("ai", "dd.rpc.xadd", { "x": 1, "y": 2})
```