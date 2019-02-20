<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>编辑股东信息</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/edit-shareholder.css" />
</head>

<body class="add-shareholder edit-basic-info">
    <div class="main">
        <p class="main-title">基本信息</p>
        <form action="/vst_admin/o2o/shareholder/edit.do" method="post" id="dataForm">
        	<input name="id" type="hidden" value="${shareholder.id}"/>
        	<input id="sholdAuditType" name="auditStatus" type="hidden" <#if shareholder??>value="${shareholder.auditStatus?upper_case}"</#if>/>
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
	                	<#if type=="COMPARED" && shareholder?? && shareholder.approveTime?? && oldShareholder??>
		                	<span>
			                	<#list oldLcations as item>${item!''}&nbsp;</#list>
		                	</span>
	                	</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        股东方：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="name" maxlength="90" type="text" data-validate="{required:true}" class="form-control w200" value="${shareholder.name!''}" />
                        <#if type=="COMPARED" && oldShareholder?? && shareholder.approveTime??>${oldShareholder.name!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label>
                        股东方类型：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                   		<select class="form-control w210" name="sholdType">
	    					<#list sholdTypes as item> 
		                    	<option value="${item.code}" <#if shareholder?? && shareholder.sholdType==item.code>selected=selected</#if> >${item.cnName}</option>
		                	</#list>
                        </select>
                        <#if type=="COMPARED" && shareholder.approveTime?? && oldShareholder??>
							<#list sholdTypes as item> 
		                    	<#if oldShareholder.sholdType==item.code>${item.cnName}</#if>
		                	</#list>
						</#if>
                    </div>
                </dd>
                <dt class="natural-person-id">
                    <label>
                        证件号码：
                    </label>
                </dt>
                <dd class="natural-person-id">
                    <div class="form-group">
                        <input type="text" maxlength="25" name="naturalPersonId" class="form-control w200" value="${shareholder.naturalPersonId!''}" />
                        <#if type=="COMPARED" && oldShareholder?? && shareholder.approveTime??>${oldShareholder.naturalPersonId!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        资质：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input type="text" maxlength="25" name="aptitude" class="form-control w200" value="${shareholder.aptitude!''}"/>
                        <#if type=="COMPARED" && shareholder.approveTime?? && oldShareholder??>${oldShareholder.aptitude!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        备注：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input type="text" maxlength="2000" name="remarks" class="form-control w200" value="${shareholder.remarks!''}"/>
                        <#if type=="COMPARED" && shareholder.approveTime?? && oldShareholder??>${oldShareholder.remarks!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        法定代表人：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="legalRep" maxlength="25" type="text" class="form-control w200" value="${shareholder.legalRep!''}" />
                        <#if type=="COMPARED" && shareholder.approveTime?? && oldShareholder??>${oldShareholder.legalRep!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        注册地址：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="registeredAddress" maxlength="120" type="text" class="form-control w200" value="${shareholder.registeredAddress!''}"/>
                        <#if type=="COMPARED" && shareholder.approveTime?? && oldShareholder??>${oldShareholder.registeredAddress!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        经营地址：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="businessAddress" maxlength="120" type="text" class="form-control w200" value="${shareholder.businessAddress!''}"/>
                        <#if type=="COMPARED" && shareholder.approveTime?? && oldShareholder??>${oldShareholder.businessAddress!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        邮编：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="zip" type="text" data-validate="{regular:仅支持输入字母数字}" data-validate-regular="^[A-Za-z0-9]{1,6}$" maxlength="6" class="form-control w200" value="${shareholder.zip!''}" />
                        <#if type=="COMPARED" && shareholder.approveTime?? && oldShareholder??>${oldShareholder.zip!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        公司网址：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <input name="site" maxlength="40" type="text" class="form-control w200" value="${shareholder.site!''}" />
                        <#if type=="COMPARED" && shareholder.approveTime?? && oldShareholder??>${oldShareholder.site!''}</#if>
                    </div>
                </dd>
                <dt>
                    <label for="">
                        股东状态：
                    </label>
                </dt>
                <dd>
                    <div class="form-group">
                        <select class="form-control w200" name="sholdStatus">
	    					<option value='Y' <#if shareholder?? && shareholder.sholdStatus == 'Y'>selected</#if>>有效</option>
	                    	<option value='N' <#if shareholder?? && shareholder.sholdStatus == 'N'>selected</#if>>无效</option>
                        </select>
                        <#if type=="COMPARED" && shareholder.approveTime?? && oldShareholder??>
                        	<#if oldShareholder.sholdStatus == 'Y'>有效</#if>
                        	<#if oldShareholder.sholdStatus == 'N'>无效</#if>
						</#if>
                    </div>
                </dd>
            </dl>
            <div class="btn-group text-center">
            	<#if type?upper_case=="WRITABLE" && shareholder?? && shareholder.auditStatus?upper_case != "SUBMITTED">
            		<@mis.checkPerm permCode="5126">
            			<a class="btn btn-primary JS_btn_save">保存</a>
        			</@mis.checkPerm >
        		</#if>
            </div>
        </form>
    </div>
    <script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
    <script src="http://pic.lvmama.com/js/backstage/v1/vst/subcompany/edit-shareholder.js"></script>
    <script>
    $(function() {

        var $document = $(document);
        
        //回写审核状态
        $("#auditType",window.parent.document).val($("#sholdAuditType").val());
        <#if shareholder?? && shareholder.sholdType!='NATURAL_PERSON'>
             $(".natural-person-id").hide();
        </#if>
        $("select[name='sholdType']").bind('change', function() {
            var sholdType = $(this).val();
            if(!!sholdType && sholdType.toUpperCase() != "NATURAL_PERSON") {
                $(".natural-person-id input[name='naturalPersonId']").val("");
                $(".natural-person-id").hide();
            } else {
                $(".natural-person-id").show();
            }
        });
        
        <#if errorMsg??>
        	backstage.alert({
   		  		content: "${errorMsg}"
   		  	});
        </#if>
<#if type=="READONLY" || type="COMPARED">
	console.log("${type}");
</#if>
<#if type=="WRITABLE">
	console.log("${type}");
</#if>
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
                backstage.confirm({
                	content: "确定要修改么？",
                	determineCallback: function(){
						$.ajax({
							url : "/vst_admin/o2o/shareholder/edit.do",
							type : "post",
							dataType : 'json',
							data : $("#dataForm").serialize(),
							success : function(result) {
								loading.destroy();
								if(result.code == "success"){
									//为父窗口设置shareholderId
									$("#shareholderId",window.parent.document).val(result.attributes.shareholderId);
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
