<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>${bindErrorInfo!'绑定产品成功'}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
    <link href="http://pic.lvmama.com/styles/backstage/v1/vst/base.css" rel="stylesheet">
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/activity-management/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/activity-management/active.css"/>
</head>
<body class="active">
<div class="savaSuccess" style="margin-left:auto;margin-right:auto;width:450px">
    <#if bindErrorInfo??>
        <div class="colSuccess">${bindErrorInfo}</div>
    <#else>
        <#if repeatedProductIds??>
            <div class="colSuccess">重复绑定的产品Id列表为</div>
            <div class="colSuccess">【${repeatedProductIds}】</div>
        <#else>
            <div class="colSuccess">绑定成功!</div>
        </#if>
    </#if>

    <div class="btn-group text-center">
        <a class="btn btn-primary JS_btn_stop">继续绑定产品</a>
        <a class="btn btn-primary JS_btn_back">返回已绑定产品列表</a>
    </div>
</div>




<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/vst/activity-management/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/vst/activity-management/active.js"></script>
<script>
    $(function(){
        var $document=$(document);
        $document.on("click",'.JS_btn_stop',function(){
            window.parent.bindSucDialog.close()
        });
        $document.on("click",'.JS_btn_back',function(){
//            window.parent.addAttachDialog.destroy();
            window.parent.location.reload();
        });
    })
</script>

</body>
</html>
