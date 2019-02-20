<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/verify-dialog.css" />
</head>
<body class="verify-dialog">  
<div class="main">
	<form id="auditForm">
		<input name="id" type="hidden" value="${id!''}"/>
		
		<div class="radio-div">
            <label><input type="radio" name="auditStatus" value="PASSED"><span>审核通过</span></label>
        </div>
        <div class="radio-div">
            <label><input type="radio" name="auditStatus" value="FAILED"><span>审核不通过</span></label>
        </div>
        <textarea name="memo" id="memo" rows="5" maxlength="2000"></textarea>

        <div class="btn-group">
            <a class="btn btn-primary JS_btn_save">提交</a>
            <a class="btn JS_btn_cancel">取消</a>
        </div>
	</form>
</div>
<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
</body>
</html>
<script>
	var url;
<#if type?upper_case == "SHOLD">
url = "/vst_admin/o2o/shareholder/audit.do";
<#elseif type?upper_case == "SUB_CO">
url = "/vst_admin/o2o/subCompany/audit.do";
<#elseif type?upper_case == "ASSCO_CO">
url = "/vst_admin/o2o/sholdAssCompany/audit.do";
</#if>
$(function () {
	var $document = $(document);
	$document.on("click", ".JS_btn_save", function() {
		var $checked = $("input[name='auditStatus']:checked");
		if(!!$checked && $checked.length <= 0) {
			backstage.alert({
	   			content: "请先选择审核结果"
	   		});
			return;
		}
		var checkedVal = $checked.val(),
			memo = $("textarea[name='memo']").val();
		if(checkedVal === "FAILED" && $.trim(memo) === '') {
			backstage.alert({
	   			content: "审核不通过必须给出驳回理由"
	   		});
			return;
		}
		var loading = backstage.loading({
			    title: "系统提醒消息",
			    content: '<p><i class="icon-loading"></i>' + '正在保存中' + '</p>'
			});
		$.ajax({
			url : url,
			type : 'post',
			dataType : 'json',
			data : $("#auditForm").serialize(),
			success : function(result) {
				loading.destroy();
				if(result.code == "success"){
					backstage.alert({
						content: result.message, 
						callback: function(){
							window.parent.searchHandler();
							window.parent.auditFormDialog.destroy();
						}
					});
				}else {
					backstage.alert({
			   			content: result.message
			   		});
				}
			},
			error : function(){
				loading.destroy();
			}
	    })
    });
	$document.on("click", ".JS_btn_cancel", function() {
    	window.parent.auditFormDialog.destroy();
    });
});
</script>