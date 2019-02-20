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

<body class="edit-contract-info">
<div class="main">
<form id="contractForm" method="post">
	<input name="id" id="contractId" type="hidden" <#if contract??>value="${contract.id!''}"</#if>/>
	<input name="subCompanyId" type="hidden" value="${subCompanyId!''}" />
    <dl class="clearfix">
        <dt>
            <label for="">
                合同签署方：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <select name="contractSubjectType" class="form-control w210 JS_contract_signatory">
					<#list contractSubjectTypes as list>
                		<option value=${list.code!''} <#if contract?? && contract.contractSubjectType==list.code>selected</#if> >${list.cnName!''}</option>
                	</#list>
        		</select>
        		<#if shareholders??>
	                <div class="shareholder-div shold">
	                	<#list shareholders as item>
	                		<span class="mr10">
		                        <label>
		                            <input type="checkbox" class="selected-sholds" <#if selectedSholdIds?? && selectedSholdIds?seq_contains(item.id?string) >checked="checked"</#if> data-id="${item.id}" />${item.name!''} 
		                        </label>
		                    </span>
	                	</#list>
	                </div>
                </#if>
                <#if parentShareholders??>
                    <div class="shareholder-div parent-shold">
                        <#list parentShareholders as item>
                            <span class="mr10">
                                <label>
                                    <input type="checkbox" class="selected-sholds" <#if selectedSholdIds?? && selectedSholdIds?seq_contains(item.id?string) >checked="checked"</#if> data-id="${item.id}" />${item.name!''} 
                                </label>
                            </span>
                        </#list>
                    </div>
                </#if>
                <input name="partnerShareholderIds" type="hidden" />
            </div>
        </dd>
        <dt>
            <label>
                合同类型：
            </label>
        </dt>
        <dd>
            <div class="form-group">
            	<select name="contractType" class="form-control w210 mr5">
					<#list contractTypes as list>
                		<option value=${list.code!''} <#if contract?? && contract.contractType==list.code>selected</#if> >${list.cnName!''}</option>
                	</#list>
        		</select>
                <input type="text" maxlength="25" name="contractTypeNote" class="form-control w200 va1" <#if contract??>value="${contract.contractTypeNote!''}"</#if> />
            </div>
        </dd>
        <dt>
            <label for="">
                合同主体：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input type="text" maxlength="50" name="contractSubject" data-validate="{required:true}" class="form-control w200" <#if contract??>value="${contract.contractSubject!''}"</#if> />
            </div>
        </dd>
        <dt>
            <label for="">
                合同编号：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input type="text" maxlength="40" name="contractNo" class="form-control w200" <#if contract??>value="${contract.contractNo!''}"</#if> />
            </div>
        </dd>
        <dt>
            <label for="">
                合同期限：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input style="width:95px;" <#if contract??>value="${contract.startTime?string('yyyy-MM-dd')}"</#if> type="text" name="startTime" class="Wdate" id="d4321" onFocus="WdatePicker({readOnly:true,maxDate:'#F{$dp.$D(\'d4322\',{d:1});}'})" required=true>&nbsp;-&nbsp;
            	<input style="width:95px;" <#if contract??>value="${contract.endTime?string('yyyy-MM-dd')}"</#if> type="text" name="endTime" class="Wdate" id="d4322" onFocus="WdatePicker({startDate:'#F{$dp.$D(\'d4321\',{y:1});}',readOnly:true,minDate:'#F{$dp.$D(\'d4321\',{d:1});}'})" required=true>
            </div>
        </dd>
        <dt>
            <label for="">
                签署日期：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input type="text" style="width:208px;" <#if contract??>value="${contract.signTime?string('yyyy-MM-dd')}"</#if> name="signTime" class="Wdate" id="d4320" onFocus="WdatePicker({readOnly:true,maxDate:'#F{$dp.$D(\'d4321\',{d:0});}'})" required=true>
            </div>
        </dd>
        <dt>
            <label for="">
                O2O业务经理：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="manager" maxlength="25" type="text" class="form-control w200" <#if contract??>value="${contract.manager!''}"</#if>/>
            </div>
        </dd>
        <dt>
            <label for="">
                行政经办人：
            </label>
        </dt>
        <dd>
            <div class="form-group">
                <input name="operator" maxlength="25" type="text" class="form-control w200" <#if contract??>value="${contract.operator!''}"</#if> />
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
    var $shareholderDiv = $('.shareholder-div.shold'),
        $parentShareholderDiv = $('.shareholder-div.parent-shold');

    <#if errorMsg??>
    	backstage.alert({
	  		content: "${errorMsg}"
	  	});
    </#if>

    var $form = $("#contractForm");
    var validateAdd = backstage.validate({
        $area: $form,
        REQUIRED: "不能为空",
        showError: true
    });
    validateAdd.watch();
    // 合同签署方
    contractSubjectTypeHandle = function(){
        var contractSignatory = $(".JS_contract_signatory").val();
        if(contractSignatory == 'SHOLD'){
            $shareholderDiv.show();
            $parentShareholderDiv.hide();
        }else if(contractSignatory == 'PARENT_SHOLD'){
            $shareholderDiv.hide();
            $parentShareholderDiv.show();
        } else {
             $shareholderDiv.hide();
             $parentShareholderDiv.hide();
        }
    };
    $document.on('change','.JS_contract_signatory', contractSubjectTypeHandle);
    contractSubjectTypeHandle();

    $document.on("click", ".JS_btn_save", function() {
        validateAdd.refresh();
        validateAdd.watch();
        validateAdd.test();
        var contractSignatory = $(".JS_contract_signatory").val();
        if(contractSignatory=='SHOLD') {
        	var $selectedSholds = $(".shareholder-div.shold input.selected-sholds:checked"),
        		selectedIds = [],
        		len = $selectedSholds.length;
    		if(len <= 0) {
    			backstage.alert({
	   		  		content: "请选择股东"
	   		  	});
    			return;
    		}
        	for(var i = 0; i < len; ++i) {
        		selectedIds.push($($selectedSholds[i]).data("id"));
        	}
        	$("input[name='partnerShareholderIds']").val(selectedIds.toString());
        } else if(contractSignatory == 'PARENT_SHOLD') {
            var $selectedSholds = $(".shareholder-div.parent-shold input.selected-sholds:checked"),
                selectedIds = [],
                len = $selectedSholds.length;
            if(len <= 0) {
                backstage.alert({
                    content: "请选择父级合作股东"
                });
                return;
            }
            for(var i = 0; i < len; ++i) {
                selectedIds.push($($selectedSholds[i]).data("id"));
            }
            $("input[name='partnerShareholderIds']").val(selectedIds.toString());
        } else {
            $("input[name='partnerShareholderIds']").val("");
        }
        if (validateAdd.getIsValidate()) {
        	var contractId = $("#contractId").val(),
        		url;
            if(!!contractId) {
            	url = "/vst_admin/o2o/subCompany/contract/edit.do";
            } else {
            	url = "/vst_admin/o2o/subCompany/contract.do";
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
					   		  			$("#subco_contract", window.parent.parent.document).parent("li").click();
					   		  			window.parent.dialogContractInfoDetail.destroy();
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
				cancelCallback:function(){
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