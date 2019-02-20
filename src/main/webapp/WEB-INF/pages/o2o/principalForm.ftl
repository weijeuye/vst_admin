<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/shareholder-director.css" />
<form id="principalForm" class="main">
	<input name="id" id="principalId" type="hidden" <#if principal??>value="${principal.id!''}"</#if>/>
	<input name="workforType" type="hidden" value="${workforType!''}" />
	<input name="workforId" type="hidden" value="${workforId!''}" />
    <dl class="clearfix">
        <dt>
            <label for="">
                姓名：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="name" maxlength="25" type="text" data-validate="{required:true}" class="form-control w200" <#if principal??>value="${principal.name!''}"</#if>/>
                <#if type?upper_case=="COMPARED" && principal.approveTime?? && oldPrincipal??>${oldPrincipal.name!''}</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                职务：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="jobtitle" maxlength="50" type="text" class="form-control w200" <#if principal??>value="${principal.jobtitle!''}"</#if>/>
                <#if type?upper_case=="COMPARED" && principal.approveTime?? && oldPrincipal??>${oldPrincipal.jobtitle!''}</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                手机：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="mobile" maxlength="25" type="text" class="form-control w200" <#if principal??>value="${principal.mobile!''}"</#if>/>
                <#if type?upper_case=="COMPARED" && principal.approveTime?? && oldPrincipal??>${oldPrincipal.mobile!''}</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                QQ号：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="qq" maxlength="25" type="text" class="form-control w200" <#if principal??>value="${principal.qq!''}"</#if>/>
                <#if type?upper_case=="COMPARED" && principal.approveTime?? && oldPrincipal??>${oldPrincipal.qq!''}</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                邮箱：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="mail" maxlength="40" type="text" class="form-control w200" <#if principal??>value="${principal.mail!''}"</#if>/>
                <#if type?upper_case=="COMPARED" && principal.approveTime?? && oldPrincipal??>${oldPrincipal.mail!''}</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                电话：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="tel" maxlength="25" type="text" class="form-control w200" <#if principal??>value="${principal.tel}"</#if>/>
                <#if type?upper_case=="COMPARED" && principal.approveTime?? && oldPrincipal??>${oldPrincipal.tel!''}</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                传真：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="fax" maxlength="25" type="text" class="form-control w200" <#if principal??>value="${principal.fax}"</#if>/>
                <#if type?upper_case=="COMPARED" && principal.approveTime?? && oldPrincipal??>${oldPrincipal.fax!''}</#if>
            </div>
        </dd>
    </dl>
</form>
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
<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script>
$(function() {

    var $document = $(document);

    <#if errorMsg??>
    	backstage.alert({
	  		content: ${errorMsg}
	  	});
    </#if>

    var $form = $("#principalForm");
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
        	var principalId = $("#principalId").val(),
        		url;
            if(!!principalId) {
            	url = "/vst_admin/o2o/principal/edit.do";
            } else {
            	url = "/vst_admin/o2o/principal.do";
            }
        	$(".JS_btn_save").hide();
        	var loading = backstage.loading({
				    title: "系统提醒消息",
				    content: '<p><i class="icon-loading"></i>' + '正在保存中' + '</p>'
				});
            backstage.confirm({
            	content: "确定要保存么？",
            	determineCallback: function(){
					$.ajax({
						url : url,
						type : 'post',
						dataType : 'json',
						data : $("#principalForm").serialize(),
						success : function(result) {
							loading.destroy();
							if(result.code == "success"){
								if(!!window.parent.principalDialog && typeof window.parent.principalDialog.destroy == "function") {
							   		backstage.alert({
							   			content: result.message,
							   			callback: function(){
							   				$("#subco_principal", window.parent.parent.document).parent("li").click();
											window.parent.principalDialog.destroy();
							   			}
							   		});
								} else {
									backstage.alert({
							   			content: result.message,
							   			callback: function(){
							   				$(".JS_btn_save").show();
							   			}
							   		});
								}
							}else {
								backstage.alert({
						   			content: result.message,
						   			callback: function(){
						   				$(".JS_btn_save").show();
						   			}
						   		});
							}
						},
						error : function(){
							loading.destroy();
							$(".JS_btn_save").show();
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