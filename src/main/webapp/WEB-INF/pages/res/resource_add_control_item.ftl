<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>新增子预控</title>
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
                    <span class="text-danger">*</span> 子预控类型：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <div class="col w90">
                        <label>
                            <input name="itemControlClass" type="radio" value="add" checked="checked" data-validate="{required:true}"/>
                            追加
                        </label>
                    </div>
                    <div class="col w90">
                        <label>
                            <input name="itemControlClass" type="radio" value="subtract"  data-validate="{required:true}"/>
                            减少
                        </label>
                    </div>
                </div>
            </dd>
            
            <dt>
                <label>
                    <span class="text-danger">*</span> 子预控预控方式：
                </label>
            </dt>
            <dd>
                <div class="JS_radio_switch_group form-group w530">
                    <div class="col w265 JS_radio_switch_box">
                        <span class="">
                        <#if controlType == "amount">
	                        <label>
	                            <input name="showItemControlType" class="JS_radio_switch" type="radio" disabled="disabled" value="amount"
	                                  checked="checked" data-validate="{required:true}"/>
	                            	预控金额
	                        </label>
	                        
	                        <span class="form-group">
	                        <input id="amounta"  name="quantity" type="text" class="form-control w110 JS_radio_disabled" data-validate="{required:true}"/>
                        	</span>
                        <#else>
                          	 <label>
	                            <input name="showItemControlType" class="JS_radio_switch" type="radio" disabled="disabled" value="amount"
	                                   data-validate="{required:true}"/>
	                           	 预控金额
	                        </label>
	                        
	                        <span class="form-group">
	                        <input id="amounta" name="quantity" type="text" class="form-control w110 JS_radio_disabled" data-validate="{required:true}"
	                               disabled="disabled" readonly="readonly"/>
                        	</span>
                        </#if>
                        </span>
                    </div>
                    <div class="col w265 JS_radio_switch_box">
                        <span class="">
                        <#if controlType == "inventory">
	                        <label>
	                            <input name="showItemControlType" class="JS_radio_switch" type="radio" disabled="disabled" value="inventory"
	                                  checked="checked" data-validate="{required:true}"/>
	                              	预控库存
	                        </label>
	                        
	                        <span class="form-group">
	                        	<input id="amountb" name="quantity" type="text" class="form-control w110 JS_radio_disabled" data-validate="{required:true}"/>
                        	</span>
                        <#else>
                        <label>
	                            <input  name="showItemControlType" class="JS_radio_switch" type="radio" value="inventory"  disabled="disabled" 
	                                   data-validate="{required:true}"/>
	                             	 预控库存
	                        </label>
	                        
	                        <span class="form-group">
	                        <input id="amountb" name="quantity" type="text" class="form-control w110 JS_radio_disabled" data-validate="{required:true}"
	                               disabled="disabled"/>
	                        </span>
                        </#if>
                        </span>
                    </div>
                </div>
            </dd>
		<input type="hidden" class="JS_autocomplete_pm_hidden" id="precontrolPolicyId" value="${precontrolPolicyId}" name="precontrolPolicyId"/>
		<input type="hidden" class="JS_autocomplete_pm_hidden" id="itemControlType" value="${controlType}" name="itemControlType"/>
        </dl>

        <div class="btn-group text-center w600">
            <a class="btn btn-primary JS_item_btn_save">保存</a>
            <a class="btn JS_item_btn_cancel quxiao">取消</a>
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

        var $form = $(".main").find("form");
        var validateAdd = backstage.validate({
            $area: $form,
            REQUIRED: "不能为空",
            showError: true
        });
        //validateAdd.test();
        validateAdd.watch();

        $document.on("click", ".JS_item_btn_save", function () {
            validateAdd.refresh();
            validateAdd.watch();
            validateAdd.test();
            if (validateAdd.getIsValidate()) {
            		var precontrolPolicyId=$("#precontrolPolicyId").val();
            		var controlType=$("#itemControlType").val();
            		//校验正整数
            		var suma=$("#amounta").val();
     				var sumb=$("#amountb").val();
			        var tt=/^\d+$/g;
			        if(!tt.test(suma)&&!tt.test(sumb)){
				        //alert("对不起，请输入正整数!")
				        backstage.alert({content: "对不起，请输入正整数!"});
				        return;
      				}
                    backstage.confirm({
                    content: "确认提交吗？",
                    determineCallback: function() {
                        $.ajax({
                        url: "/vst_admin/goods/recontrol/addResourceControlItem.do",
                        type: "POST",
                        cache: false,
                        dataType:"json",
                        async : false,
                        data:$("#saveButton").serialize(),
                        success: function (result) {
                            //返回成功则关闭当前窗口
                            if(result.code == 1) {
                            	parent.location.href="/vst_admin/goods/recontrol/goToEditResPrecontrolPolicy/view.do?id="+precontrolPolicyId;
                            }else{
                            	backstage.alert({content: "保存失败,"+result.msg});
                            }
                        }
                    	});
                    }
                });
               
            }
        });
            $document.on("click", ".JS_item_btn_cancel", function() {
                parent.dialogViewOrder.destroy();
               });
        });
    
</script>
</body>
</html>