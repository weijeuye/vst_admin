<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>编辑付款流水</title>
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
                    <span class="text-danger">*</span> 付款日期：
                </label>
            </dt>
            <dd>
            	<span class="form-group">
                <input name="payDate" id="payDate" type="text" placeholder="选择时间" class="form-control datetime w200 JS_play_date"
                           readonly="readonly" data-validate-readonly="true" value="${resPrecontrolPayment.payDate?string("yyyy-MM-dd")}"/>
                </span>
                
            </dd>
            
            <dt>
                <label>
                    <span class="text-danger">*</span> 付款金额：
                </label>
            </dt>
            <dd>
              	<div class="form-group col mr10">
                    <input name="amountStr" id="amountStr" type="text" class="form-control w200 JS_amountStr" value="${resPrecontrolPayment.amountYuanStr!''}"
                           data-validate="{required:true}"/>
                </div>
                <span id="spanAmountStr" class="text-gray"></span>
            </dd>
            
            <!-- <dt>
                <label>
                    <span class="text-danger">*</span> 操作人：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <input name="payPerson" id="payPerson" maxlength="20" type="text" class="form-control w200 JS_payPerson"
                           data-validate="{required:true}"/>
                </div>
                <span id="spanPayPerson" class="text-gray"></span>
            </dd> -->
            <dt>
                <label>
                    备注：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <textarea id="memo"  name="memo"  maxlength=300 style="width:300px; height:100px;" class="form-control w200 JS_memo" />${resPrecontrolPayment.memo!''}</textarea>
                </div>
                <span id="spanMemo" class="text-gray"></span>
            </dd>
			<input type="hidden" class="JS_autocomplete_pm_hidden" id="precontrolPolicyId" value="${precontrolPolicyId}" name="precontrolPolicyId"/>
			<input type="hidden" class="JS_autocomplete_pm_hidden" id="paymentId" value="${resPrecontrolPayment.paymentId!''}" name="paymentId"/>
        </dl>

        <div class="btn-group text-center w600">
            <a class="btn btn-primary JS_btn_save">保存</a>
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
      //校验输入的金额是否是数字
      $document.on("blur", ".JS_amountStr", function() {
	      var amountStr=$("#amountStr").val();
	      //校验正数字（小数位不超过2位）
	      var tt=/^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2})))$/;
		  if(!tt.test(amountStr)){
			  $("#spanAmountStr").html("*付款金额请输入正的数字(最多两位小数)").css("color","red");
			  var amountStr=$("#amountStr").val("");
          }else{
	         $("#spanAmountStr").html("");
	      }
      });
      //操作人长度
     /*  $document.on("blur", ".JS_payPerson", function() {
	      var payPerson=$("#payPerson").val();
	      
	      var lentrim=$.trim(payPerson).length;
		  if(lentrim>20){
			 $("#spanPayPerson").html("*操作人最多输入20字").css("color","red");
		  }else{
		  	 $("#spanPayPerson").html("");
		  }
      }); */
      $document.on("blur", ".JS_memo", function() {
	    var name=$("#memo").val();
	    var len=name.length;
	    if(len>300){
          $("#spanMemo").html("*备注最多输入300字").css("color","red");
        }else{
          $("#spanMemo").html("");
        }
     });
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

        $document.on("click", ".JS_btn_save", function () {
            validateAdd.refresh();
            validateAdd.watch();
            validateAdd.test();
            if (validateAdd.getIsValidate()) {
            		var precontrolPolicyId=$("#precontrolPolicyId").val();
					var amountStr=$("#amountStr").val();
					/* var payPerson=$("#payPerson").val(); */
					var memo=$("#memo").val();
					var payDate=$("#payDate").val();
					if(payDate==null || payDate==""){
						//alert("请选择付款日期!");
						backstage.alert({content: "对不起，请输入付款日期!"});
						return;
					}
					
	              	//校验金额
					var tt=/^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2})))$/;
	              	if(!tt.test(amountStr)){
						//alert("对不起，付款金额请输入正的数字(最多两位小数)!");
						backstage.alert({content: "对不起，付款金额请输入正的数字(最多两位小数)!"});
						return;
					}
					//校验操作人
				/* 	 var lentrim=$.trim(payPerson).length;
					 if(lentrim>20){
						//alert("操作人最多20个字!")
						backstage.alert({content: "操作人最多20个字!"});
						return;
					 } */
			
					var len=memo.length;
				    if(len>300){
				    	//alert("备注最多输入300字!");
				    	backstage.alert({content: "备注最多输入300字!"});
	         			return;
				    }
                    backstage.confirm({
                    content: "确认提交吗？",
                    determineCallback: function() {
                        $.ajax({
                        url: "/vst_admin/goods/recontrol/editResourceControlPayment.do",
                        type: "POST",
                        cache: false,
                        dataType:"json",
                        async : false,
                        data:$("#saveButton").serialize(),
                        success: function (result) {
                            //返回成功则关闭当前窗口
                            if(result.code == 'success') {
                            	parent.location.href="/vst_admin/goods/recontrol/goToResControlPaymentMain/view.do?precontrolPolicyId="+precontrolPolicyId;
                            }else{
                            	backstage.alert({content: "保存失败,"+result.msg});
                            }
                        }
                    	});
                    }
                });
            }
        });
            $document.on("click", ".JS_btn_cancel", function() {
                parent.dialogViewOrder.destroy();
               });
        });
    
</script>
</body>
</html>