<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body style="position:relative">	
<div class="iframe_content mt10">
	<div class="clearfix title">
		<h2 class="f16">下单必填项<i class="cc1">(<#if comOrderRequired??>更新<#else>新增</#if>)</i></h2>
        <input type="hidden" name="productType" value="${(suppGoods.prodProduct.productType)!''}">
		<#if comOrderRequired??>
			<input type="hidden" name="url" value="/vst_admin/goods/traffic/updateReservationLimit.do">
		<#else>
			<input type="hidden" name="url" value="/vst_admin/goods/traffic/addReservationLimit.do">
		</#if>
	 </div>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <div class="tiptext tip-warning cc5"><span class="tip-icon tip-icon-warning"></span>注：
        <p class="pl15">1. 代表该品类只需要一个游玩人即可。</p>
        <p class="pl15">2. 代表该品类基于“数量关联”有几个游玩人就需要填写几个。</p>
    </div>
	<#include "/goods/traffic/goods/reservationLimit.ftl"/>
	<div class="p_box box_info clearfix mb20">
   		<div class="fl operate"><a class="btn btn_cc1" id="reservationLimitButton">保存</a>
   		<a class="btn" id="backToLastPageButton">返回上一步</a></div>
 	</div>
 </div>

 <#include "/base/foot.ftl"/>
</body>
</html>
<script>

	$(function () {

        var productType = $("input[name='productType']").val();
        var prodType = '';
        if(productType == 'INNERLINE'){
            prodType = 'INNER';
        }else if(productType == 'FOREIGNLINE'){
            prodType = 'OUT';
        }
        //初始化整个页面
        showRequire($("input[name='categoryId']").val(),prodType,"");

        $("#reservationLimitButton").click(function(){

            if(!$("#reservationLimitForm").validate().form()){
                return false;
            }

            var checkedCred = $("input[name=credType]:checked").val();
            var hasValid =false;
            if(checkedCred=="TRAV_NUM_ONE"||checkedCred=="TRAV_NUM_ALL"){
                $("input[name$=Flag][value=Y]").each(function(){
                    if($(this).is(':checked')){
                        hasValid = true;
                    }
                });
                if(checkedCred=="TRAV_NUM_ONE"&&!hasValid){
                    alert("您选择的证件为一个游玩人，则可用证件类型为必选项，请修改。");
                    return false;
                }
                if(checkedCred=="TRAV_NUM_ALL"&&!hasValid){
                    alert("您选择的证件为全部游玩人，则可用证件类型为必选项 ，请修改。");
                    return false;
                }
            }

            var url =  $("input[name='url']").val();
            $.ajax({
                url : url,
                data :$("#reservationLimitForm").serialize(),
                dataType:'JSON',
                success : function(result){
                    $.alert(result.message,function(){
                        window.history.go(-1);
                    });
                },
                error : function(){
                    $.alert(result.message);
                }
            })
        });

        $("#backToLastPageButton").click(function(){
            window.history.go(-1);
        });
    });

</script>
