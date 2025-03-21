# 保存依赖包

```bash
pip freeze > ./requirements.txt
```

# 还原依赖包

```bash
pip install -r ./requirements.txt
```

# 开发

每个接口有三个文件，都放到一个目录里，用三级目录定义调用键。如实例一个加法服务，键为 **dd.rpc.add** ，要编写三个文件。

* api/dd/rpc/add/main.py：为接口主代码，用export变量暴露函数。

```python
def xadd(x=0, y=1):
    return x + y
export = xadd
```

* api/dd/rpc/add/main.json：为接口元数据，用于定义输入、输出、测试用例。

* api/dd/rpc/add/main.md：为接口描述，用于在元数据外的详细描述。

## 模型训练与预测

* 输入三个参数，分别为x,y,i。
* 输出一个字典，包含输入、输出、模型。

```python
from sklearn import linear_model
def learn(x, y, i):
    model = linear_model.LinearRegression()
    model.fit(x, y)
    result = {}
    result["i"] = i
    result["o"] = model.predict(i).tolist()    
    result["m"] = {
        "coef_": model.coef_.tolist()
    }
    return result
export = learn
```