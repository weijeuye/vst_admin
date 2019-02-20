<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>推送预控期订单</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/resource-add-control.css"/>
</head>
<body class="resource-add-control">

<div class="main mt10">
    <form id="saveButton">
        <dl class="clearfix">
            <dt>
                <label>
                    <span class="text-danger">*</span> 预控id：
                </label>
            </dt>
            <dd>
                 <div class="form-group col mr10">
                    <textarea id="policyId" name="policyId" maxlength=300 style="width:450px; height:100px;" class="form-control w200 JS_PolicyId"/></textarea>
                </div>
                <span id="spanPolicyId" class="text-gray">可输入多个预控id，用“,”隔开</span>
            </dd>
 			
        </dl>

        <div class="btn-group text-center w700">
            <a class="btn btn-primary JS_btn_save">确定</a>
            <a class="btn JS_btn_cancel quxiao">取消</a>
        </div>
    </form>
</div>


<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/resource-add-control.js"></script>
<script>
    
    var $document = $(document);

  	//TODO 开发维护
    $(function () {
        var parent = window.parent;

        var $document = $(document);

        $document.on("click", ".JS_btn_save", function () {
             	var policyId=$("#policyId").val();
            	var lentrim=$.trim(policyId).length;
            	if(lentrim==0){
					backstage.alert({content: "请输入预控id！"});
					return;
				}
                backstage.confirm({
                content: "确认提交吗？",
                    determineCallback: function() {
                        $.ajax({
                        url: "/vst_admin/percontrol/suppGoods/pushHistoryOrder.do",
                        type: "POST",
                        cache: false,
                        dataType:"json",
                        async : false,
                        //data:$("#saveButton").serialize(),
                        data:{policyId:policyId},
                        success: function (result) {
                            //返回成功则关闭当前窗口
                            if(result.code == 1) {
                             	alert(result.msg);
                            	//parent.location.href="/vst_admin/goods/recontrol/find/resPrecontrolPolicyList.do";
                             	//parent.dialogViewOrder.destroy();
                            }else{
                            	alert("保存失败,"+result.msg);
                            }
                        }
                    	});
                    }
                });
        });
        $document.on("click", ".JS_btn_cancel", function() {
                parent.dialogViewOrder.destroy();
               });
        });
    
</script>
</body>
</html>