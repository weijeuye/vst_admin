<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>解绑产品成功</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
    <link href="http://pic.lvmama.com/styles/backstage/v1/vst/base.css" rel="stylesheet">
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/activity-management/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/activity-management/active.css"/>
</head>
<body class="active">
<div class="savaSuccess">
    <div class="colSuccess">解绑成功!</div>
    <div class="btn-group text-center">
        <a class="btn btn-primary JS_btn_stop">确定</a>
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
            window.parent.addAttachDialog.destroy();
        });
        $document.on("click",'.JS_btn_back',function(){
//            window.parent.addAttachDialog.destroy();
            window.parent.parent.location.reload();
        });
    })
</script>

</body>
</html>
