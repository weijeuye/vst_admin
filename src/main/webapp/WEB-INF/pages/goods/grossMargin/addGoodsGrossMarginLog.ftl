<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    
</head>
<body>

<div>
<form id="lowPriceForm">
<div>
    <div><span style="color:red">*此产品包含低毛利商品，如需审核通过，请选择上架原因。</span></div>
	<table>
		<tr>
			<td><span style="color:red">*</span>低毛利类别：</td>
            <td><select name="reasonType" ><option value="PROMOTION">优惠促销</option><option value="ONSALE">低价甩卖</option><option value="COMPETITION">同业竞争</option><option value="OTHER">其他</option></select></td>
		</tr>
        <tr>
			<td><span style="color:red">*</span>原因说明:</td>
			<td><input type="text" name="reason" id="reason"/></td>
		</tr>
	</table>
    <div class="p_box box_info clearfix mb20">
        <div class="fl operate"><a class="btn btn_cc1" id="timePriceSaveButton_margin">保存</a><a class="btn" id="cancel_margin">取消</a></div>
    </div>
</div>
</form>
<script>
	$("#timePriceSaveButton_margin").click(function (){
		if($("#reason").val()==""){
			alert("请输入原因");
			return;
		}
		if($("#reason").val().length>=100){
			alert("最多输入100个字符");
			return;
		}
		//提交低毛利率
        submitLowPrice();
		//提交时间价格表
        submitTimePrice();
		
	});
	$("#cancel_margin").click(function (){
        lowPriceDialog.close();
	});
</script>
</div>
</body>
<html>