<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>批量导入</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
    <link href="http://pic.lvmama.com/styles/backstage/v1/vst/base.css" rel="stylesheet">
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/activity-management/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/activity-management/active.css"/>
</head>
<body class="active">
<div class="baseInformation" style="height:700px;display: block;">
    <form>
        <dl class="clearfix">
            <input type="hidden" name="announcementId" id="announcementId" value="${announcementId}">
            <dt>
                <label for="descId">
                    <span class="text-danger">*</span> 产品ID：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
						<textarea class="w35 textWidth" style="height: 250px; width: 550px" maxlength="3000"
							name="productIds" id="productIds" placeholder="可输入多个ID进行进行绑定，ID间以“,”隔开（英文逗号分隔，最大长度3000，最多1000个ID）"
							onchange="javascript:if(this.value!='')this.value=(this.value.replace(/[，]/g,',')).replace(/[^0-9,]/g,'');"
							required></textarea>
					</div>
            </dd>
        </dl>
        <div class="btn-group text-center">
            <a class="btn btn-primary JS_btn_bound"  target="_parent">绑定产品</a>
        </div>
    </form>
</div>
<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/vst/activity-management/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/vst/activity-management/active.js"></script>
<script src="http://s3.lvjs.com.cn/js/ui/lvmamaUI/lvmamaUI.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/v1/common/dialog.js"></script>
<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/normalize.css" type="text/css"/>
<#include "/base/foot.ftl"/>
<script>

    //TODO 开发维护
    $(function () {
       $(".JS_btn_bound").click(function(){
           var announcementId = $("#announcementId").val();
           var productIds = $("#productIds").val();
           var myreg = /^(([0-9]|,)*)$/;
           if(!myreg.test(productIds))
           {
               alert('请输入有效的产品ID');
               return false;
           }
           $.ajax({
               url: "/vst_admin/prod/destinationAnnouncement/batchBind.do",
               type: "POST",
               cache: false,
               dataType : 'json',
               data : {productIds:productIds,announcementId:announcementId},
               success:
                       function(data){
                           if(data.code=="success"){
                               backstage.alert({
                                   content:data.message
                               });
                               batchBindDialog.close();
                           }else{
                        	   var msg = "";
                        	   if(data.message!=null){
                        		   msg="绑定失败"+":"+data.message;
                               }else{
                            	   msg="绑定失败";
                               }
                               backstage.alert({
                            	   content:msg
                               });
                           }
                       },
               error: function () {
                   backstage.alert({
                       content:"绑定失败"
                   });
               }
           });
       });
     })
</script>

</body>
</html>
