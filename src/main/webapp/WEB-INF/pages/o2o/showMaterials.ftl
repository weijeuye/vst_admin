<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>编辑资质</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
</head>

<body class="edit-contract-attachment my-body">
    <div class="main">
        <p class="main-title">资质</p>
        <#include "/o2o/materialsForm.ftl">
        <div class="btn-group text-center">
        	<#if type?upper_case=="WRITABLE" && auditType?upper_case != "SUBMITTED">
	        	<#if dataRefer?? && dataRefer?upper_case=="SHOLD">
					<@mis.checkPerm permCode="5126">
						<a class="btn btn-primary JS_btn_save">保存</a>
					</@mis.checkPerm >
				<#elseif dataRefer?? && dataRefer?upper_case=="SUB_CO">
					<@mis.checkPerm permCode="5120">
						<a class="btn btn-primary JS_btn_save">保存</a>
					</@mis.checkPerm >
				</#if>
    		</#if>
        </div>
    </div>
    <script>
    var delIds = []
    	changeFlag = 0;
    $(function() {

        var $document = $(document);
        var $template = $(".template");

        // 表单验证
        var $form = $(".main").find("form");
        var validateAdd = backstage.validate({
            $area: $form,
            REQUIRED: "不能为空",
            showError: true
        });
        validateAdd.watch();

        $document.on("click", ".JS_btn_save", function() {
            validateAdd.refresh();
            validateAdd.watch();
            validateAdd.test();
            if (validateAdd.getIsValidate()) {
            	$(".JS_btn_save").hide();
            	var loading = backstage.loading({
				    title: "系统提醒消息",
				    content: '<p><i class="icon-loading"></i>' + '正在保存中' + '</p>'
				});
			 	var data = new FormData(document.forms.namedItem("materialsForm"));
			 	if(delIds.length > 0) {
			 		console.log(delIds);
			 		data.append("delIds[]", delIds);
			 	}
			 	if(delIds.length == 0 && changeFlag <= 0) {
			 		backstage.alert({
		   		  		content: "您未做任何改动。",
		   		  		callback: function () {
		   		  			$(".JS_btn_save").show();
		   		  			loading.destroy();
		   		  		}
		   		  	});
		   		  	return;
			 	}
                backstage.confirm({
                	content: "确认提交吗 ？",
                	determineCallback: function () {
						$.ajax({
						   url : "/vst_admin/o2o/materials.do",
						   processData: false,
						   contentType: false,
						   type:"POST",
						   data:data,
						   success : function(result){
						   		loading.destroy();
							   	if(result.code=="success"){
							   		backstage.alert({
							   			content: result.message,
							   			callback: function () {
							   				if(!!window.parent.posMaterialsDialog && typeof window.parent.posMaterialsDialog.destroy == "function") {
							   					window.parent.posMaterialsDialog.destroy();
							   				} else {
									   			$(".JS_btn_save").show();
								   				$("#materials",window.parent.document).parent("li").click();
							   				}
							   			}
							   		});
							   	}else {
						   		  	backstage.alert({
						   		  		content: result.message,
						   		  		callback: function () {
						   		  			$(".JS_btn_save").show();
						   		  		}
						   		  	});
						   		}
						   },
							error : function(result){
								backstage.alert({
					   		  		content: "系统异常",
					   		  		callback: function () {
										loading.destroy();
										$(".JS_btn_save").show();
					   		  		}
					   		  	});
							}
						  })
					},
					cancelCallback: function(){
						loading.destroy();
						$(".JS_btn_save").show();
					}
				});
            }
        });
    });
    </script>
</body>

</html>
