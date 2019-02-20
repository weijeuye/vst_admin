<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>新增预控</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/resource-add-control.css"/>
</head>
<body class="resource-add-control">

<div class="main">
    <form id="saveButton">
    	<input type="hidden" name="isCanDelay" value="N" />
        <dl class="clearfix">
            <dt>
                <label for="ControlName">
                    <span class="text-danger">*</span> 预控名称：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <input name="name" id="ControlName" type="text" class="form-control w200 JS_pre_name"
                           data-validate="{required:true}"/>
                </div>

                <span id="spanId" class="text-gray"></span>
            </dd>
            <dt>
                <label for="ProviderName">
                    <span class="text-danger">*</span> 供应商名称：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <input name="supplierName" id="ProviderName" type="text" class="form-control search w200 JS_autocomplete_pn"
                           data-validate="{required:true}"/>
                    <input id="supplierId" name="supplierId" type="hidden" class="JS_autocomplete_pn_hidden"/>
                </div>        
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span> 预控方式：
                </label>
            </dt>
            <dd>
                <div class="JS_radio_switch_group form-group">
                    <div class="col w270 JS_radio_switch_box">
                        <span class="">
                        <label>
                            <input name="controlType" class="JS_radio_switch" type="radio" value="amount"
                                   data-validate="{required:true}"/>
                            预控金额
                        </label>
                        </span>
                        <span class="form-group">
                        <input id="amounta" name="amount" type="text" class="form-control w110 JS_radio_disabled" data-validate="{required:true}"
                               disabled="disabled"/>
                        </span>
                    </div>
                    <div class="col JS_radio_switch_box">
                        <span class="">
                        <label>
                            <input  name="controlType" class="JS_radio_switch" type="radio" value="inventory"
                                   data-validate="{required:true}"/>
                              预控库存
                        </label>
                        </span>
                        <span class="form-group">
                        <input id="amountb" name="amount" type="text" class="form-control w110 JS_radio_disabled" data-validate="{required:true}"
                               disabled="disabled"/>
                        </span>
                    </div>
                </div>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span> 销售起止日期：
                </label>
            </dt>
            <dd>
                <span class="form-group">
                    <input name="saleEffectDate" type="text" placeholder="起始时间" class="form-control datetime w100 JS_sale_date"
                           data-validate="{required:true}"
                           readonly="readonly" data-validate-readonly="true"/>
                </span>
                -
                <span class="form-group">
                    <input name="saleExpiryDate"  type="text" placeholder="结束时间" class="form-control datetime w100 JS_sale_date"
                           data-validate="{required:true}"
                           readonly="readonly" data-validate-readonly="true"/>
                </span>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span> 游玩起止日期：
                </label>
            </dt>
            <dd>
                <span class="form-group">
                    <input name="tradeEffectDate" type="text" placeholder="起始时间" class="form-control datetime w100 JS_play_date"
                           data-validate="{required:true}"
                           readonly="readonly" data-validate-readonly="true"/>
                </span>
                -
                <span class="form-group">
                    <input name="tradeExpiryDate" type="text" placeholder="结束时间" class="form-control datetime w100 JS_play_date"
                           data-validate="{required:true}"
                           readonly="readonly" data-validate-readonly="true"/>
                </span>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span> 预控类型：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <div class="col w90">
                        <label>
                            <input name="controlClassification" value="Daily" type="radio" data-validate="{required:true}" class="JS_control_type"/>
                            按日预控
                        </label>
                    </div>
                    <div class="col w90">
                        <label>
                            <input name="controlClassification" value="Cycle" type="radio" data-validate="{required:true}" class="JS_control_type"/>
                            按周期预控
                        </label>
                    </div>
                </div>
                <span class="text-gray"></span>
            </dd>
            
            <dt>
                <label for="ControlName">
                    <span class="text-danger">*</span> 是否测试：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <div class="col w90">
                        <label>
                            <input name="isTest" type="radio" value="Y" data-validate="{required:true}"/>
                            是
                        </label>
                    </div>
                    <div class="col w90">
                        <label>
                            <input name="isTest" type="radio" value="N"  checked="checked" data-validate="{required:true}"/>
                            否
                        </label>
                    </div>
                </div>
            </dd>
            
            <dt>
                <label>
                    <span class="text-danger">*</span> 能否退还：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <div class="col w90">
                        <label>
                            <input name="isCanReturn" type="radio" value="Y" data-validate="{required:true}"/>
                            是
                        </label>
                    </div>
                    <div class="col w90">
                        <label>
                            <input name="isCanReturn" type="radio" value="N"  checked="checked" data-validate="{required:true}"/>
                            否
                        </label>
                    </div>
                </div>
                <span class="text-gray">注：如果到期卖不完，能否退还给供应商</span>
            </dd>
           <#-- <dt>
                <label>
                    <span class="text-danger">*</span> 能否超卖：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <div class="col w90">
                        <label>
                            <input name="isCanDelay" type="radio" value="Y" data-validate="{required:true}"/>
                            是
                        </label>
                    </div>
                    <div class="col w90">
                        <label>
                            <input name="isCanDelay" type="radio" value="N"  checked="checked" data-validate="{required:true}"/>
                            否
                        </label>
                    </div>
                </div>
            </dd>-->
            <#-- <dt>
                <label for="buCode">
                    <span class="text-danger">*</span> 所属BU：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <select name="buCode" class="form-control" data-validate="{required:true}">
                        <option value="">请选择</option>
                        <option value="LOCAL_BU">国内游事业部</option>
                        <option value="OUTBOUND_BU">出境游事业部</option>
                        <option value="DESTINATION_BU">目的地事业部</option>
                        <option value="TICKET_BU">景区玩乐事业群</option>
                        <option value="BUSINESS_BU">商旅定制事业部</option>
                    </select>
                </div>
            </dd>-->
            
            <dt>
                <label for="buCode">
                    <span class="text-danger">*</span> 所属BU：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <select name="buCode" id="selBuCode" class="form-control" data-validate="{required:true}">
			            <option value="">请选择BU</option>
			        </select>
			        所属大区
			        <select  name="area1" id="selArea1" class="form-control">
			            <option value="">请选择大区</option>
			        </select>
					<select class="form-control" name="area2" id="selArea2" style="display:none" >
						<option value="">请选择分区</option>
					</select>
                </div>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span>买断总成本：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <input name="buyoutTotalCostStr" id="buyoutTotalCostStr" type="text" class="form-control w200 JS_buyoutTotalCost"
                           data-validate="{required:true}"/>
                </div>
                <span id="spanBuyoutTotalCostStr" class="text-gray"></span>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span>预估营业额：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <input name="forecastSalesStr" id="forecastSalesStr" type="text" class="form-control w200 JS_forecastSales"
                           data-validate="{required:true}"/>
                </div>
                <span id="spanForecastSalesStr" class="text-gray"></span>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span>押金：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <input name="depositAmountStr" id="depositAmountStr" type="text" class="form-control w200 JS_depositAmount"
                           data-validate="{required:true}"/>
                </div>
                <span class="text-gray">*提示：可填写0</span>
                <span id="spanDepositAmountStr" class="text-gray"></span>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span>冠名金额：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <input name="nameAmountStr" id="nameAmountStr" type="text" class="form-control w200 JS_nameAmount"
                           data-validate="{required:true}"/>
                </div>
                 <span class="text-gray">*提示：可填写0</span>
                 <span id="spanNameAmountStr" class="text-gray"></span>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span>项目性质：
                </label>
            </dt>
            <dd> 
                <div class="form-group">
                    <select name="projectNature" id="projectNature" class="form-control" data-validate="{required:true}">
                        <option value="">请选择</option>
                        <option value="buyout">买断</option>
                        <option value="predeposit">预存款</option>
                        <option value="monthdeposit">押金+月结</option>
                        <option value="depositpredeposit">押金+预存款</option>
                        <option value="name">冠名</option>
                        <option value="buyoutpredeposit">买断+预存款</option>
                    </select>
                </div>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span>付款方式：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <div class="col w100">
                        <label>
                            <input name="payWay" type="radio" value="one" checked="checked" data-validate="{required:true}"/>
                            一次全额付款
                        </label>
                    </div>
                    <div class="col w100">
                        <label>
                            <input name="payWay" type="radio" value="more" data-validate="{required:true}"/>
                            多次付款
                        </label>
                    </div>
                </div>
                <span class="text-danger">注：多次付款，请备注说明每次付款时间和金额；</span>
            </dd>
            <dt>
                <label>
                    付款备注：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <textarea id="payMemo" name="payMemo" maxlength=300 style="width:450px; height:70px;" class="form-control w200 JS_payMemo"/></textarea>
                </div>
                <span id="spanPayMemo" class="text-gray"></span>
            </dd>
            
            <dt>
                <label for="ProductManager">
                    <span class="text-danger">*</span> 产品经理：
                </label>
            </dt>

            <dd>
                <div class="form-group">
                    <input name="productManagerName" id="ProductManager" type="text"
                           class="form-control search w110 JS_autocomplete_pm"
                           data-validate="{required:true}"/>
                            <!--   产品经理的的id-->
                     <input type="hidden" class="JS_autocomplete_pm_hidden" id="ProductManagerId" name="productManagerId"/>
                     <input type="hidden" class="JS_autocomplete_pm_hidden_email" id="ProductManagerEmail" name="ProductManagerEmail"/>
                </div>
                
            </dd>
            <dt>
                <label>
                    	 备注：
                </label>
            </dt>
            <dd>
                 <div class="form-group col mr10">
                    <textarea id="memo" name="memo"  maxlength=300 style="width:450px; height:70px;" class="form-control w200 JS_memo"/></textarea>
                </div>
                <span id="spanMemo" class="text-gray"></span>
            </dd>
            <dt>
                <label>
                    <span class="text-danger">*</span> 提醒设置：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                    <!--按日预控 开始-->
                    <p class="JS_control_type_item none" data-type="Daily">
                        <label class="checkbox">
                            <input name="code" type="checkbox" data-validate="{required:true}" value="everyday"/>
                            每天晚上24点整，发邮件提醒。
                        </label>
                    </p>
                    <!--按日预控 结束-->
                    <!--按周期预控 开始-->
                    <p class="JS_control_type_item none" data-type="Cycle">
                        <label class="checkbox">
                            <input name="code" type="checkbox" data-validate="{required:true}" value="everyweek"/>
                            从起始时间算起，之后的每个周一，发邮件提醒。
                        </label>
                    </p>    

                    <p class="JS_control_type_item none" data-type="Cycle">
                        <label.
                         class="checkbox">
                            <input name="code" type="checkbox" data-validate="{required:true}" value="loss"/>
                            每当“金额/库存”减少
                            <select class="form-control" name="value">
                                <option  value="10">10%</option>
                                <option  value="20">20%</option>
                                <option  value="30">30%</option>
                                <option  value="40">40%</option>
                                <option  value="50">50%</option>
                                <option  value="60">60%</option>
                                <option  value="70">70%</option>
                                <option  value="80">80%</option>
                                <option  value="90">90%</option>
                            </select>
                            发邮件提醒。
                        </label>
                    </p>
                    <!--按周期预控 结束-->
                    <p>
                        <label class="checkbox">
                            <input name="code" type="checkbox" data-validate="{required:true}" value="lossAll"/>
                            买断“金额/库存”全部消耗完时，发邮件提醒我。
                        </label>
                    </p>

                    <p>
                         <label class="checkbox">
                            <input name="code" type="checkbox" data-validate="{required:true}" value="finish"/>
                            买断期结束时，发邮件提醒我。
                        </label>
                    </p>
                </div>
            </dd>
            <dt></dt>
            <dd>
                <div class="col w75">抄送其他人：</div>
                <div class="cc_box JS_cc_box clearfix">
                    <div class="col w150 cc JS_cc form-group">
                        <input name="receiverName" type="text"
                               class="form-control search w110 JS_autocomplete_cc"
                              />
                        <input type="hidden" class="JS_autocomplete_cc_hidden" name="ids"/>
                        <input type="hidden" class="JS_autocomplete_cc_hidden_email" name="email"/>
                               
                    </div>
                    <div class="col cc JS_cc_add">
                        <a>继续添加</a>
                    </div>
                </div>
            </dd>
        </dl>
        <div class="btn-group text-center">
            <a class="btn btn-primary JS_btn_save">保存</a>
            <a class="btn JS_btn_cancel quxiao">取消</a>
        </div>
    </form>
</div>

<!--模板 开始-->
<div class="template">

    <!--抄送 开始-->
    <div class="col w150 cc JS_cc form-group">
        <input name="receiverName" type="text" class="form-control search w110 JS_autocomplete_cc" />
        <a class="text-danger JS_cc_del">X</a>
        <input type="hidden" class="JS_autocomplete_cc_hidden" name="ids"/>
        <input type="hidden" class="JS_autocomplete_cc_hidden_email" name="email"/>
    </div>
    <!--抄送 结束-->

</div>
<!--模板 结束-->

<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/resource-add-control.js"></script>
<script type="text/javascript" src="/vst_admin/js/res/resource_add_control.js"></script>
<script>
    /* 
    var $document = $(document);
    //预控名称blur事件
    $document.on("blur", ".JS_pre_name", function() {
    var name=$("#ControlName").val();
    $.ajax({
       url:"/vst_admin/goods/recontrol/findresPrecontrolPolicyName.do",
       dataType:"json",
       data:{name:name},
       success:function(data){
       if(data.name=="N"){
       var name=$("#ControlName").val("");
       $("#spanId").html("项目名不能重复").css("color","red");
       }else{
         $("#spanId").html("");
       }
   }
 });
        console.log(this);
    });
    
    $document.on("blur", ".JS_memo", function() {
    var name=$("#memo").val();
    var len=name.length;
    if(len>300){
         $("#spanMemo").html("*备注最多输入300字").css("color","red");
       }else{
         $("#spanMemo").html("");
       }
    });


  //检出输入的数据是否有负数
      $document.on("blur", ".JS_radio_disabled", function() {
      var suma=$("#amounta").val();
      var sumb=$("#amountb").val();

      var tt=/^\d+$/g;
      if(!tt.test(suma)&&!tt.test(sumb)){
      alert("对不起，预控金额/库存请输入正整数")
     var suma=$("#amounta").val("");
      var sumb=$("#amountb").val("");
      }
      });
      //校验输入的买断总成本是否是数字
      $document.on("blur", ".JS_buyoutTotalCost", function() {
	      var buyoutTotalCost=$("#buyoutTotalCostStr").val();
	      //校验非负数字（小数位不超过2位）
	      var tt=/^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2}))|[0])$/;
		  if(!tt.test(buyoutTotalCost)){
			  $("#spanBuyoutTotalCostStr").html("*买断总成本请输入非负的数字(最多两位小数)").css("color","red");
			  var buyoutTotalCost=$("#buyoutTotalCostStr").val("");
          }else{
	         $("#spanBuyoutTotalCostStr").html("");
	      }
      });
       $document.on("blur", ".JS_forecastSales", function() {
	      var forecastSales=$("#forecastSalesStr").val();
	      var tt=/^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2}))|[0])$/;
	      if(!tt.test(forecastSales)){
		      $("#spanForecastSalesStr").html("*预估营业额请输入非负的数字(最多两位小数)").css("color","red");
		      var forecastSales=$("#forecastSalesStr").val("");
      	  }else{
      	  	  $("#spanForecastSalesStr").html("");
      	  }
      });
      $document.on("blur", ".JS_depositAmount", function() {
	      var depositAmount=$("#depositAmountStr").val();
	      var tt=/^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2}))|[0])$/;
	      if(!tt.test(depositAmount)){
		      $("#spanDepositAmountStr").html("*押金请输入非负的数字(最多两位小数)").css("color","red");
		      var depositAmount=$("#depositAmountStr").val("");
      	  }else{
      	      $("#spanDepositAmountStr").html("");
      	  }
      });
      $document.on("blur", ".JS_nameAmount", function() {
	      var nameAmount=$("#nameAmountStr").val();
	      var tt=/^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2}))|[0])$/;
	      if(!tt.test(nameAmount)){
		      $("#spanNameAmountStr").html("*冠名金额请输入非负的数字(最多两位小数)").css("color","red");
		      var nameAmount=$("#nameAmountStr").val("");
      	  }else{
      	   	  $("#spanNameAmountStr").html("");
      	  }
      });
      
    $document.on("blur", ".JS_payMemo", function() {
    var name=$("#payMemo").val();
    var len=name.length;
    if(len>300){
         $("#spanPayMemo").html("*付款备注最多输入300字").css("color","red");
       }else{
         $("#spanPayMemo").html("");
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
                console.log("提交表单");
                var buyoutTotalCost = $("#buyoutTotalCostStr").val();
                var forecastSales = $("#forecastSalesStr").val();
                var depositAmount = $("#depositAmountStr").val();
                var nameAmount = $("#nameAmountStr").val();
                var memo = $("#memo").val();
                var payMemo = $("#payMemo").val();
                var payWay = $("input[name='payWay']:checked").val();
                var buCode = $('#selBuCode option:selected').val();
                var area1 = $('#selArea1 option:selected').val();
                var area2 = $('#selArea2 option:selected').val();


                if (buCode != "BUSINESS_BU") {
                    if (area1 == null || area1 == "") {
                        alert("对不起，请选择所属大区");
                        return;
                    }
                }
                if (buCode == "TICKET_BU") {
                    if (area2 == null || area2 == "") {
                        alert("对不起，请选择所属分区");
                        return;
                    }
                }

                //校验金额
                var tt = /^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2}))|[0])$/;
                if (!tt.test(buyoutTotalCost)) {
                    alert("对不起，买断总成本请输入非负的数字(最多两位小数)");
                    return;
                }
                if (!tt.test(forecastSales)) {
                    alert("对不起，预估营业额请输入非负的数字(最多两位小数)");
                    return;
                }
                if (!tt.test(depositAmount)) {
                    alert("对不起，押金请输入非负的数字(最多两位小数)");
                    return;
                }
                if (!tt.test(nameAmount)) {
                    alert("对不起，冠名金额请输入非负的数字(最多两位小数)")
                    return;
                }

                if (payWay == "more") {
                    var lentrim = $.trim(payMemo).length;
                    if (lentrim == 0) {
                        alert("多次付款方式，请填写付款备注说明")
                        return;
                    }
                }
                var len = payMemo.length;
                if (len > 300) {
                    alert("付款备注最多输入300字!");
                    return;
                }
                //校验备注长度
                var len1 = memo.length;
                if (len1 > 300) {
                    alert("备注最多输入300字!");
                    return;
                }
            }
                    backstage.confirm({
                    content: "确认提交吗？",
                    determineCallback: function() {
                        $.ajax({
                            url: "/vst_admin/goods/recontrol/addResourceControl.do",
                            type: "POST",
                            cache: false,
                            data: $("#saveButton").serialize(),
                            success: function (result) {
                                if (result == "success") {
                                    var tradeEffectStr = $("input[name='tradeEffectDate']").val();
                                    var arr1 = tradeEffectStr.split("-");
                                    var tradeEffectDate = new Date(arr1[0], parseInt(arr1[1]) - 1, arr1[2]);
                                    var nowDate = new Date();
                                    if (nowDate > tradeEffectDate) {
                                        backstage.alert({
                                            content: "温馨提示！" + "您项目录入时间晚于项目开始时间，可能存在历史商品ID或者已经在线售卖的商品ID，"
                                            + "建议您及时绑定商品方便后续同步历史已产生消耗的数据；"
                                            + "保证项目数据的完整性和准确性；",
                                            callback: function () {
                                                parent.location.href = "/vst_admin/goods/recontrol/find/resPrecontrolPolicyList.do";
                                                parent.dialogViewOrder.destroy();
                                            }
                                        });
                                    } else {
                                        backstage.alert({
                                            content: "保存成功"
                                        });
                                        parent.location.href = "/vst_admin/goods/recontrol/find/resPrecontrolPolicyList.do";
                                        parent.dialogViewOrder.destroy();
                                    }
                                } else {
                                    backstage.alert({
                                        content: "保存失败"
                                    });
                                }
                            }
                        });
                    }
                });
               
        });

        $document.on("click", ".quxiao", function() {
            parent.dialogViewOrder.destroy();
           });
       
    });
        
   
 
    //供应商名称自动完成
    $(function () {
        backstage.autocomplete({
            "query": ".JS_autocomplete_pn",
            "fillData": fillData,
            "choice": choice,
            "clearData": clearData
        });
        function fillData(self) {
            var url = "/vst_admin/goods/recontrol/findSuppSupplier.do"; 
            var text = self.$input.val();
            console.log(text);
            self.loading();
            $.ajax({
                url: url,
                data: {name: text},
                dataType:"json",
                success: function (json) {
                    var $ul = self.$menu.find("ul");
                    $ul.empty();
                    for (var i = 0; i < json.length; i++) {
                        var $li = $('<li data-id="' + json[i].id + '">' + json[i].name + '</li>');
                        $ul.append($li)
                    }

                    self.loaded();
                }
            });
        }

        function choice(self, $li) {

            var id = $li.attr("data-id");
            var $hidden = self.$input.parent().find(".JS_autocomplete_pn_hidden");
            $hidden.val(id);
            }
        function clearData(self) {
            var $hidden = self.$input.parent().find(".JS_autocomplete_pn_hidden");
            $hidden.val("");
        }
    });

    //产品经理自动完成
    $(function () {
        backstage.autocomplete({
            "query": ".JS_autocomplete_pm",
            "fillData": fillData,
            "choice": choice,
            "clearData": clearData
        });
        function fillData(self) {
            var url = "/vst_admin/goods/recontrol/findMangement.do";
            var text = self.$input.val();
            self.loading();
            console.log(text);
            $.ajax({
                url: url,
                data: {name: text},
                dataType:"json",
                success: function (json) {
                    var $ul = self.$menu.find("ul");
                    $ul.empty();
                    for (var i = 0; i < json.length; i++) {
                       var $li = $('<li data-email="'+json[i].email+'" data-id="' + json[i].id + '">' + json[i].name + '</li>');
                        $ul.append($li)
                    }

                    self.loaded();
                }
            });
        }

        function choice(self, $li) {
            var id = $li.attr("data-id");
            var email = $li.attr("data-email");
            var $hidden = self.$input.parent().find(".JS_autocomplete_pm_hidden");
            var $email = self.$input.parent().find(".JS_autocomplete_pm_hidden_email");
            $hidden.val(id);
            $email.val(email);
        }
         function clearData(self) {
            var $email = self.$input.parent().find(".JS_autocomplete_pm_hidden_email");
            $email.val("");
            var $hidden = self.$input.parent().find(".JS_autocomplete_pm_hidden");
            $hidden.val("");
        }
    });

    //抄送自动完成
    $(function () {
        backstage.autocomplete({
            "query": ".JS_autocomplete_cc",
            "fillData": fillData,
            "choice": choice,
            "clearData": clearData
        });
        function fillData(self) {
            var url = "/vst_admin/goods/recontrol/findSend.do";
            self.loading();
            var text = self.$input.val();
            console.log(text);
            $.ajax({
                url: url,
                data: {name: text},
                dataType:"json",
                success: function (json) {
                    var $ul = self.$menu.find("ul");
                    $ul.empty();
                    for (var i = 0; i < json.length; i++) {
                      var $li = $('<li data-email="'+json[i].email+'" data-id="' + json[i].id + '">' + json[i].name + '</li>');
                      $ul.append($li)
                    }

                    self.loaded();
                }
            });
        }
        function choice(self, $li) {
            var id = $li.attr("data-id");
            var email = $li.attr("data-email");
            var $hidden = self.$input.parent().find(".JS_autocomplete_cc_hidden");
            var $hiddenEmail = self.$input.parent().find(".JS_autocomplete_cc_hidden_email");
            $hidden.val(id);
            $hiddenEmail.val(email);
           }
           function clearData(self) {
            var $hidden = self.$input.parent().find(".JS_autocomplete_cc_hidden");
            var $hiddenEmail = self.$input.parent().find(".JS_autocomplete_cc_hidden_email");
            $hidden.val("");
            $hiddenEmail.val("");
        }
    });
    
	//初始化BU 大区下拉框
     $(function(){
  	areaDataJson=[
		    {"buid":"LOCAL_BU",
		     "buname":"国内游事业部",
		     "area1":[
		        {"aid":"bjbranch",
			 "aname":"北京分公司"
		        },
			{"aid":"cdbranch",
			 "aname":"成都分公司"
		        },
			{"aid":"gzbranch",
			 "aname":"广州分公司"
		        },
			{"aid":"shhead",
			 "aname":"上海总部"
		        }
		    ]},
		    {"buid":"OUTBOUND_BU",
		     "buname":"出境游事业部",
		     "area1":[
		        {"aid":"shout",
			 "aname":"上海出境"
		        },
			{"aid":"bjout",
			 "aname":"北京出境"
		        },
			{"aid":"gzout",
			 "aname":"广州出境"
		        },
			{"aid":"cdout",
			 "aname":"成都出境"
		        }
		    ]},
		    {"buid":"DESTINATION_BU",
		     "buname":"目的地事业部",
		     "area1":[
		        {"aid":"bjbranch",
			 "aname":"北京分公司"
		        },
			{"aid":"cdbranch",
			 "aname":"成都分公司"
		        },
			{"aid":"gzbranch",
			 "aname":"广州分公司"
		        },
			{"aid":"zenarea",
			 "aname":"浙东北大区"
		        },
			{"aid":"zwnarea",
			 "aname":"浙西南大区"
		        },
			{"aid":"scnarea",
			 "aname":"苏中北大区"
		        },
			{"aid":"snarea",
			 "aname":"苏南大区"
		        },
			{"aid":"sharea",
			 "aname":"上海大区"
		        },
			{"aid":"hbarea",
			 "aname":"湖北大区"
		        },
			{"aid":"aharea",
			 "aname":"安徽大区"
		        },
			{"aid":"jxarea",
			 "aname":"江西大区"
		        },
			{"aid":"outatea",
			 "aname":"境外大区"
		        },
			{"aid":"hnarea",
			 "aname":"海南大区"
		        }
		    ]},
		    {"buid":"TICKET_BU",
		     "buname":"景区玩乐事业群",
		     "area1":[
		        {"aid":"eastarea",
			 "aname":"东区",
		         "area2":[
		            {"pid":"shanghai","pname":"上海"},
		            {"pid":"jaingsu","pname":"江苏"},
			    {"pid":"zhejiang","pname":"浙江"},
			    {"pid":"jiangxi","pname":"江西"},
		            {"pid":"fujian","pname":"福建"}
		        ]},
			{"aid":"southarea",
			 "aname":"南区",
		         "area2":[
		            {"pid":"guangdong","pname":"广东"},
		            {"pid":"hunan","pname":"湖南"},
			    	{"pid":"guangxi","pname":"广西"},
			    	{"pid":"hainan","pname":"海南"}
		        ]},
			{"aid":"northarea",
			 "aname":"北区",
		         "area2":[
		            {"pid":"beijing","pname":"北京"},
		            {"pid":"tianjin","pname":"天津"},
			    {"pid":"hebei","pname":"河北"},
			    {"pid":"shandong","pname":"山东"},
			    {"pid":"heilongjiang","pname":"黑龙江"},
			    {"pid":"jilin","pname":"吉林"},
			    {"pid":"liaoning","pname":"辽宁"},
			    {"pid":"neimenggu","pname":"内蒙古"}
		        ]},
			{"aid":"westarea",
			 "aname":"西区",
		         "area2":[
		            {"pid":"chongqing","pname":"重庆"},
		            {"pid":"sichuan","pname":"四川"},
		            {"pid":"yunnan","pname":"云南"},
		            {"pid":"guizhou","pname":"贵州"},
		            {"pid":"xinjiang","pname":"新疆"},
		            {"pid":"gansu","pname":"甘肃"},
		            {"pid":"ningxia","pname":"宁夏"},
		            {"pid":"qinghai","pname":"青海"},
		            {"pid":"xizang","pname":"西藏"}
		        ]},
			{"aid":"centralarea",
			 "aname":"中区",
		         "area2":[
		            {"pid":"henan","pname":"河南"},
		            {"pid":"shanxi","pname":"陕西"},
		            {"pid":"anhui","pname":"安徽"},
		            {"pid":"hubei","pname":"湖北"},
		            {"pid":"shanxip","pname":"山西"}
		        ]},
			{"aid":"outboundarea",
			 "aname":"出境",
		         "area2":[
		            {"pid":"xinmayin","pname":"新马印"},
		            {"pid":"oumeiaofei","pname":"欧美澳非"},
		            {"pid":"taiyuejian","pname":"泰越柬"},
		            {"pid":"riben","pname":"日本"},
		            {"pid":"hanguo","pname":"韩国wifi"},
		            {"pid":"gangao","pname":"港澳"}
		        ]}
		    ]},
		    {"buid":"BUSINESS_BU",
		     "buname":"商旅定制事业部"
		    }
		];
            //初始化BU
            var bucode = function(){
                $.each(areaDataJson,function(i,bucode){
                    var option="<option value='"+bucode.buid+"'>"+bucode.buname+"</option>";
					 $("#selBuCode").append(option);
                });
                area1();
            };
            //赋值大区
            var area1 = function(){
				$("#selArea2").css("display","none");
				$("#selArea1 option:gt(0)").remove();
                var n = $("#selBuCode").get(0).selectedIndex-1;
                $.each(areaDataJson[n].area1,function(i,area1){
                    var option="<option value='"+area1.aid+"'>"+area1.aname+"</option>";
					 $("#selArea1").append(option);
                });
                area2();
            };
            //赋值分区
            var area2 = function(){
				$("#selArea2 option:gt(0)").remove(); 
                var m = $("#selBuCode").get(0).selectedIndex-1;
                var n =  $("#selArea1").get(0).selectedIndex-1;
                if(typeof(areaDataJson[m].area1[n].area2) != "undefined"){
                  $("#selArea2").css("display","inline");
                    $.each(areaDataJson[m].area1[n].area2,function(i,area2){
                        var option="<option value='"+area2.pid+"'>"+area2.pname+"</option>";
						$("#selArea2").append(option);
                    });
                };
            };
            //选择省改变市
            $("#selBuCode").change(function(){
                area1();
            });
            //选择市改变县
             $("#selArea1").change(function(){
                area2();
            });
                bucode();
    }); */
    
</script>
</body>
</html>