<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>产品商品基本信息</title>
    <#include "/base/head_meta.ftl"/>

    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/vst-line-travel.css"/>
    
    <link rel="shortcut icon" href="http://www.lvmama.com/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/v1/vst/base.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/v1/vst/product-feature/product-feature.css">

</head>
<body class="product-feature-old">
<div class="everything">

    <!--洋葱皮 开始-->
    <ol class="onionskin">
        <li>
            <a href="#">跟团游</a>
            &gt;
        </li>
        <li>
            <a href="#">产品维护</a>
            &gt;
        </li>
        <li>
            产品特色
        </li>
    </ol>
    <!--洋葱皮 结束-->

    <div class="pf-header">
        <p class="pf-tip">&nbsp;</p>
        <div class="pf-tabs clearfix">
            <a href="showUpdateProductFeature.do?productId=${productId}&packageType=${packageType}&dataFrom=fromPage">新版本</a>
            <a class="active">旧版本</a>
        </div>
        <div class="pf-tip clearfix">
            <em class="pull-left">
                注：
            </em>
            <p class="pull-left">
                1. 旧版本的文本框里内容只能复制，不能编辑。<br>
                2. 为了产品特色在驴妈妈展示的效果，请尽快将在旧版本的内容复制到新版本。
            </p>
        </div>
    </div>
    <div class="pf-movable">
		<label class="pf-label">
	                产品特色：
		</label>
		<div class="pf-content" style="border: 1px solid #999999;height: 550px;width: 800px;overflow-x:hidden;padding: 15px;" >
			${ProductDescription.content}
		</div>
	</div>

</div>


<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/kindeditor.js"></script>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/plugins/image/image.js"></script>
<script type="text/javascript" src="/vst_admin/js/contentManage/kindEditorConf.js"></script>

</body>
</html>

