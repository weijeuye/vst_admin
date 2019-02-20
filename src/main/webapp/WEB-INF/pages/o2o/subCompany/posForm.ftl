<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css" />
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/edit-shareholder.css" />
<link rel="stylesheet" href="/vst_admin/css/calendar.css" type="text/css"/>
</head>

<body class="">
<div class="edit-business-network">
<form id="posForm" method="post" class="main">
	<input name="id" id="posId" type="hidden" <#if pos??>value="${pos.id}"</#if> />
	<input name="subCompanyId" type="hidden" value="${subCompanyId!''}" />
    <dl class="clearfix">
        <dt>
            <label for="">
                所在地：
            </label>
        </dt>
        <dd>
            <div class="form-group col mr10">
                <#list locations as item> 
            		<input name="locations" maxlength="30" type="text" class="form-control w90 mr5" value="${item!''}" />
            	</#list>
            	<#if type=="COMPARED" && oldPos?? && pos.approveTime??>
                	<span>
	                	<#list oldLcations as item>${item!''}&nbsp;</#list>
                	</span>
            	</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                营业网点名称：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="name" maxlength="90" type="text" data-validate="{required:true}" class="form-control w200" <#if pos??>value="${pos.name!''}"</#if> />
                <#if type=="COMPARED" && oldPos?? && pos.approveTime??>${oldPos.name!''}</#if>
            </div>
        </dd>
        <dt>
            <label>
                旅行社许可证号：
            </label>
        </dt>
        <dd>
            <div class="form-group">
            	<select class="form-control w210" name="permitType">
                    <#list permitTypes as item> 
                    	<option value="${item.code}" <#if pos?? && pos.permitType==item.code>selected=selected</#if> >${item.cnName}</option>
                	</#list>
                </select>
                <input type="text" maxlength="40" name="permitNo" class="form-control w200" <#if pos??>value="${pos.permitNo!''}"</#if> />
                <#if type=="COMPARED" && oldPos?? && pos.approveTime??>
					<#list permitTypes as item> 
                    	<#if oldPos.permitType==item.code>${item.cnName}</#if>
                	</#list>
	                ${oldPos.permitNo!''}
				</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                分公司/营业网点许可证号：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input type="text" maxlength="40" name="posPermitNo" class="form-control w200" <#if pos??>value="${pos.posPermitNo!''}"</#if> />
                <#if type=="COMPARED" && oldPos?? && pos.approveTime??>${oldPos.posPermitNo!''}</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                网点类型：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input type="text" name="pointType" maxlength="25" class="form-control w200" <#if pos??>value="${pos.pointType!''}"</#if> />
                <#if type=="COMPARED" && oldPos?? && pos.approveTime??>${oldPos.pointType!''}</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                经营地址：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="businessAddress" maxlength="120" type="text" class="form-control w200" <#if pos??>value="${pos.pointType!''}"</#if> />
                <#if type=="COMPARED" && oldPos?? && pos.approveTime??>${oldPos.pointType!''}</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                商圈及楼宇显示：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="businessCircle" maxlength="120" type="text" class="form-control w200" <#if pos??>value="${pos.businessCircle!''}"</#if> />
                <#if type=="COMPARED" && oldPos?? && pos.approveTime??>${oldPos.businessCircle!''}</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                POS机申领编号：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="posNo" maxlength="120" type="text" class="form-control w200" <#if pos??>value="${pos.posNo!''}"</#if> />
                <#if type=="COMPARED" && oldPos?? && pos.approveTime??>${oldPos.posNo!''}</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                邮编：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="zip" type="text" maxlength="6" class="form-control w200" <#if pos??>value="${pos.zip!''}"</#if> />
                <#if type=="COMPARED" && oldPos?? && pos.approveTime??>${oldPos.zip!''}</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                店长姓名：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="posManagerName" maxlength="25" type="text" class="form-control w200" <#if pos??>value="${pos.posManagerName!''}"</#if> />
                <#if type=="COMPARED" && oldPos?? && pos.approveTime??>${oldPos.posManagerName!''}</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                手机：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="mobile" maxlength="25" type="text" class="form-control w200" <#if pos??>value="${pos.mobile!''}"</#if> />
                <#if type=="COMPARED" && oldPos?? && pos.approveTime??>${oldPos.mobile!''}</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                QQ号：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="qq" maxlength="25" type="text" class="form-control w200" <#if pos??>value="${pos.qq!''}"</#if> />
                <#if type=="COMPARED" && oldPos?? && pos.approveTime??>${oldPos.qq!''}</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                邮箱：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="mail" maxlength="40" type="text" class="form-control w200" <#if pos??>value="${pos.mail!''}"</#if> />
                <#if type=="COMPARED" && oldPos?? && pos.approveTime??>${oldPos.mail!''}</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                电话：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="tel" maxlength="25" type="text" class="form-control w200" <#if pos??>value="${pos.tel!''}"</#if> />
                <#if type=="COMPARED" && oldPos?? && pos.approveTime??>${oldPos.tel!''}</#if>
            </div>
        </dd>
        <dt>
            <label for="">
                传真：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="fax" maxlength="25" type="text" class="form-control w200" <#if pos??>value="${pos.fax!''}"</#if> />
                <#if type=="COMPARED" && oldPos?? && pos.approveTime??>${oldPos.fax!''}</#if>
            </div>
        </dd>
    </dl>
    <div class="btn-group text-center">
    	<#if type?upper_case=="WRITABLE" && auditType?upper_case != "SUBMITTED">
        	<a class="btn btn-primary JS_btn_save">保存</a>
    	</#if>
    </div>
</form>
</div>
<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script type="text/javascript" src="/vst_admin/js/My97DatePicker/WdatePicker.js"></script>
<script>
$(function() {

    var $document = $(document);

    <#if errorMsg??>
    	backstage.alert({
	  		content: "${errorMsg}"
	  	});
    </#if>

    var $form = $("#posForm");
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
        	var posId = $("#posId").val(),
        		url;
            if(!!posId) {
            	url = "/vst_admin/o2o/subCompany/pos/edit.do";
            } else {
            	url = "/vst_admin/o2o/subCompany/pos.do";
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
						data : $form.serialize(),
						success : function(result) {
							loading.destroy();
							if(result.code == "success"){
								backstage.alert({
					   		  		content: result.message,
					   		  		callback: function () {
					   		  			$("#subco_pos", window.parent.parent.document).parent("li").click();
					   		  			window.parent.posDialog.destroy();
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
</body>
</html>