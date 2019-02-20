<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>编辑基本信息</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
</head>

<body class="edit-basic-info my-body">
    <div class="main">
        <p class="main-title">基本信息</p>
        <form action="/vst_admin/o2o/subCompany.do" method="post" id="dataForm">
        	<input name="id" type="hidden" value="${subCompany.id}"/>
        	<input id="auditStatus" name="auditStatus" type="hidden" <#if subCompany??>value="${subCompany.auditStatus?upper_case}"</#if>/>
            <dl class="clearfix">
                <dt>
                    <label for="">
                        所在地：
                    </label>
                </dt>
                <dd>
                    <div class="form-group col mr10">
                        <#list locations as item> 
                    		<input name="locations" maxlength="30" type="text" class="form-control w85 mr5" value="${item!''}" />
	                	</#list>
	                	<#if type=="COMPARED" && oldSubCompany?? && subCompany.approveTime??>
		                	<span>
			                	<#list oldLcations as item>${item!''}&nbsp;</#list>
		                	</span>
	                	</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        子公司名称：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="name" type="text" data-validate="{required:true}" class="form-control w395" value="${subCompany.name!''}" <#if subCompany.approveTime??>readonly=readonly</#if> maxlength="90" placeholder="最多90个汉字" />
                    </div>
                </dd>
                <dt>
                    <label for="">
                        旅行社许可证号：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="permitNo" maxlength="50" type="text" class="form-control w200" value="${subCompany.permitNo!''}" />
                        <#if type=="COMPARED" && oldSubCompany?? && subCompany.approveTime??>${oldSubCompany.permitNo!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label>
                        资质：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <select class="form-control w210" name="aptitude">
                            <#list aptitudeTypes as item> 
		                    	<option value="${item.code}" <#if subCompany?? && subCompany.aptitude==item.code>selected=selected</#if> >${item.cnName}</option>
		                	</#list>
                        </select>
                        <#if type=="COMPARED" && oldSubCompany?? && subCompany.approveTime??>
							<#list aptitudeTypes as item> 
		                    	<#if oldSubCompany.aptitude==item.code>${item.cnName}</#if>
		                	</#list>
						</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        法定代表人：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="legalRep" maxlength="25" type="text" class="form-control w200" value="${subCompany.legalRep!''}"/>
                        <#if type=="COMPARED" && oldSubCompany?? && subCompany.approveTime??>${oldSubCompany.legalRep!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        注册地址：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="registeredAddress" maxlength="120" type="text" class="form-control w395" value="${subCompany.registeredAddress!''}"/>
                        <#if type=="COMPARED" && oldSubCompany?? && subCompany.approveTime??>${oldSubCompany.registeredAddress!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        经营地址：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="businessAddress" maxlength="120" type="text" class="form-control w395" value="${subCompany.businessAddress!''}" />
                        <#if type=="COMPARED" && oldSubCompany?? && subCompany.approveTime??>${oldSubCompany.businessAddress!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        邮编：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="zip" type="text" data-validate="{regular:仅支持输入字母数字}" data-validate-regular="^[A-Za-z0-9]{1,6}$" maxlength="6" class="form-control w200" value="${subCompany.zip!''}"/>
                        <#if type=="COMPARED" && oldSubCompany?? && subCompany.approveTime??>${oldSubCompany.zip!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        公司网址：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="site" maxlength="40" type="text" class="form-control w200" value="${subCompany.site!''}" />
                        <#if type=="COMPARED" && oldSubCompany?? && subCompany.approveTime??>${oldSubCompany.site!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        管辖区域：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="manageArea" maxlength="120" type="text" class="form-control w395" value="${subCompany.manageArea!''}" />
                        <#if type=="COMPARED" && oldSubCompany?? && subCompany.approveTime??>${oldSubCompany.manageArea!''}</#if>
                        <span class="input-tip">请用“、”隔开</span>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        子公司状态：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <select class="form-control w200" name="coStatus">
	    					<option value='Y' <#if subCompany?? && subCompany.coStatus == 'Y'>selected</#if>>有效</option>
	                    	<option value='N' <#if subCompany?? && subCompany.coStatus == 'N'>selected</#if>>无效</option>
                        </select>
                        <#if type=="COMPARED" && oldSubCompany?? && subCompany.approveTime??>
                        	<#if oldSubCompany.coStatus == 'Y'>有效</#if>
                        	<#if oldSubCompany.coStatus == 'N'>无效</#if>
						</#if>
                    </div>
                </dd>
            </dl>
            <div class="btn-group text-center">
	            <#if type?upper_case=="WRITABLE" && auditType?upper_case != "SUBMITTED">
	            	<@mis.checkPerm permCode="5120">
	                	<a class="btn btn-primary JS_btn_save">保存</a>
                	</@mis.checkPerm >
				</#if>
            </div>
        </form>
    </div>
    <script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/vst/subcompany/base.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/common/validate.js"></script>
    <script>
   $(function() {

        var $document = $(document);

	    <#if errorMsg??>
	    	backstage.alert({
		  		content: "${errorMsg}"
		  	});
	    </#if>

<#if subCompany?? && subCompany.auditStatus??>
	$("#auditType",window.parent.document).val("${subCompany.auditStatus?upper_case}");
</#if>

        // 表单验证
        var $form = $("#dataForm");
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
                backstage.confirm({
                	content: "确定要保存么？",
                	determineCallback: function(){
						$.ajax({
							url : "/vst_admin/o2o/subCompany/edit.do",
							type : "post",
							dataType : 'json',
							data : $("#dataForm").serialize(),
							success : function(result) {
								loading.destroy();
								if(result.code == "success"){
									//为父窗口设置subCompanyId
									$("#subCompanyId",window.parent.document).val(result.attributes.subCompanyId);
									backstage.alert({
						   		  		content: result.message,
						   		  		callback: function () {
						   		  			$(".JS_btn_save").show();
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
