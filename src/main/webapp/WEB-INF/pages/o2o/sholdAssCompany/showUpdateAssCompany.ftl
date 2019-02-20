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
        <form action="/vst_admin/o2o/sholdAssCompany.do" method="post" id="dataForm">
        	<input name="id" type="hidden" value="${companyId}"/>
        	<input id="auditStatus" name="auditStatus" type="hidden" <#if subCompany??>value="${sholdAssCompany.auditStatus?upper_case}"</#if>/>
            <dl class="clearfix">
                <dt>
                    <label for="">
                        关联公司名：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="name" type="text" data-validate="{required:true}" class="form-control w200" value="${sholdAssCompany.name!''}" maxlength="90" placeholder="最多90个汉字" />
                        <#if type=="COMPARED" && oldSholdAssCompany?? && sholdAssCompany.approveTime??>${oldSholdAssCompany.name!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        旅行社许可证号：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="permitNo" maxlength="50" type="text" class="form-control w200" value="${sholdAssCompany.permitNo!''}" />
                        <#if type=="COMPARED" && oldSholdAssCompany?? && sholdAssCompany.approveTime??>${oldSholdAssCompany.permitNo!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        第一负责人：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="principalName" maxlength="25" type="text" class="form-control w200" value="${sholdAssCompany.principalName!''}"/>
                        <#if type=="COMPARED" && oldSholdAssCompany?? && sholdAssCompany.approveTime??>${oldSholdAssCompany.legalRep!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        手机：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="mobile" maxlength="25" type="text" class="form-control w200" value="${sholdAssCompany.mobile!''}"/>
                        <#if type=="COMPARED" && oldSholdAssCompany?? && sholdAssCompany.approveTime??>${oldSholdAssCompany.mobile!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        QQ号：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="qq" maxlength="25" type="text" class="form-control w200" value="${sholdAssCompany.qq!''}" />
                        <#if type=="COMPARED" && oldSholdAssCompany?? && sholdAssCompany.approveTime??>${oldSholdAssCompany.qq!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        邮箱：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="mail" maxlength="40" type="text" class="form-control w200" value="${sholdAssCompany.mail!''}"/>
                        <#if type=="COMPARED" && oldSholdAssCompany?? && sholdAssCompany.approveTime??>${oldSholdAssCompany.mail!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        电话：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="tel" maxlength="25" type="text" class="form-control w200" value="${sholdAssCompany.tel!''}" />
                        <#if type=="COMPARED" && oldSholdAssCompany?? && sholdAssCompany.approveTime??>${oldSholdAssCompany.tel!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        传真：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="fax" maxlength="25" type="text" class="form-control w200" value="${sholdAssCompany.fax!''}" />
                        <#if type=="COMPARED" && oldSholdAssCompany?? && sholdAssCompany.approveTime??>${oldSholdAssCompany.fax!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        关联公司状态：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <select class="form-control w200" name="assoStatus">
	    					<option value='Y' <#if sholdAssCompany?? && sholdAssCompany.assoStatus == 'Y'>selected</#if>>有效</option>
	                    	<option value='N' <#if sholdAssCompany?? && sholdAssCompany.assoStatus == 'N'>selected</#if>>无效</option>
                        </select>
                        <#if type=="COMPARED" && oldSholdAssCompany?? && sholdAssCompany.approveTime??>
                        	<#if oldSholdAssCompany.assoStatus == 'Y'>有效</#if>
                        	<#if oldSholdAssCompany.assoStatus == 'N'>无效</#if>
						</#if>
                    </div>
                </dd>
            </dl>
            <div class="btn-group text-center">
            	<#if type?upper_case=="WRITABLE" && auditType?upper_case != "SUBMITTED">
            		<@mis.checkPerm permCode="5123">
                		<a class="btn btn-primary JS_btn_save">保存</a>
            		</@mis.checkPerm >
                </#if>
            </div>
        </form>
    </div>
    <script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/vst/subcompany/base.js"></script>
    <script>
   $(function() {

        var $document = $(document);

	    <#if errorMsg??>
	    	backstage.alert({
		  		content: "${errorMsg}"
		  	});
	    </#if>
<#if sholdAssCompany?? && sholdAssCompany.auditStatus??>
	$("#auditType",window.parent.document).val("${sholdAssCompany.auditStatus?upper_case}");
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
							url : "/vst_admin/o2o/sholdAssCompany/edit.do",
							type : "post",
							dataType : 'json',
							data : $("#dataForm").serialize(),
							success : function(result) {
								loading.destroy();
								if(result.code == "success"){
									backstage.alert({
						   		  		content: result.message,
						   		  		callback: function () {
											//为父窗口设置subCompanyId
											$("#companyId",window.parent.document).val(result.attributes.companyId);
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
