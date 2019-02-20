<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
<#include "/base/findProductInputType.ftl"/>
</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">产品维护</a> &gt;</li>
            <li class="active">添加产品</li>
        </ul>
</div>
<div class="iframe_content mt10">
<form action="/vst_admin/prod/customized/addProduct.do" method="post" id="dataForm">
		<input type="hidden" name="customizedProdId" id="productId" value="${customizedProduct.customizedProdId!''}">
		<input type="hidden" name="senisitiveFlag" value="N">
		
		<div class="p_box box_info p_line">
            <div class="box_content">
                <table class="e_table form-inline">
                    <tbody>
					<tr>
	                	<td class="e_label"><i class="cc1">*</i>产品名称：</td>
	                    <td><label><input type="text" class="w35" style="width:700px" value="${customizedProduct.productName!''}" name="productName" id="productName" required>&nbsp;请勿输入下列字符    <> % # * & ^ @ ! ~ / \ '||"</label>
	                   <div id="productNameError"></div>
	                    </td>
	                    
	                </tr>
	               	<tr>
						<td class="e_label"><i class="cc1">*</i>适合人数：</td>
						<td>
						<input type="text" style="width:50px" id="propPerson0"  name="propPerson" value="${propPerson0}" number="true" placeholder="" ">  - 
						<input type="text" style="width:50px" id="propPerson1"  name="propPerson" value="${propPerson1}" number="true" placeholder="" >
						<span id = "spanPropPerson"></span>
						</td>
	                </tr>
	                
	                <tr>
						<td class="e_label"><i class="cc1">*</i>行程特色：</td>
						<td>
							<textarea  name="feature"  rows="3" id="feature"  maxlength="1500"  style="width:500px" required=true>${customizedProduct.feature!''}</textarea>
							<span id = "spanFeature"></span>
	                    </td>
	                </tr>
	                <tr>
	                	<td class="e_label"><i class="cc1">*</i>参考价格</td>
	                 	 <td>
	                    	<input type="radio"  name="price1"  value="YTYY" required  <#if customizedProduct.price == '一团一议'>checked</#if>/>一团一议
	                    	<input type="radio"  name="price1"  value="SJ" required <#if customizedProduct.price != '一团一议'>checked</#if> />实价
	                    	<input type="text" style="width:50px" name="price"  id="priceNum" number="true" placeholder="" required=true autovalue="true" value=${customizedProduct.price!''}>
	                    </td>
	                </tr>
	                 <tr>
	                	<td class="e_label"><i class="cc1">*</i>所属分站：</td>
	                 	 <td>
	                 	 <select name="substation" required>
		                    	<option value="上海" <#if customizedProduct.substation == '上海'>selected</#if>>上海</option>
		                    	<option value="无锡" <#if customizedProduct.substation == '无锡'>selected</#if>>无锡</option>
		                    	<option value="北京" <#if customizedProduct.substation == '北京'>selected</#if>>北京</option>
		                    	<option value="天津" <#if customizedProduct.substation == '天津'>selected</#if>>天津</option>
		                    	<option value="唐山" <#if customizedProduct.substation == '唐山'>selected</#if>>唐山</option>
		                    	<option value="呼和浩特" <#if customizedProduct.substation == '呼和浩特'>selected</#if>>呼和浩特</option>
		                    	<option value="包头" <#if customizedProduct.substation == '包头'>selected</#if>>包头</option>
		                    	<option value="石家庄" <#if customizedProduct.substation == '石家庄'>selected</#if>>石家庄</option>
		                    	<option value="南京" <#if customizedProduct.substation == '南京'>selected</#if>>南京</option>
		                    	<option value="杭州" <#if customizedProduct.substation == '杭州'>selected</#if>>杭州</option>
		                    	<option value="合肥" <#if customizedProduct.substation == '合肥'>selected</#if>>合肥</option>
		                    	<option value="厦门" <#if customizedProduct.substation == '厦门'>selected</#if>>厦门</option>
		                    	<option value="济南" <#if customizedProduct.substation == '济南'>selected</#if>>济南</option>
		                    	<option value="南昌" <#if customizedProduct.substation == '南昌'>selected</#if>>南昌</option>
		                    	<option value="苏州" <#if customizedProduct.substation == '苏州'>selected</#if>>苏州</option>
		                    	<option value="宁波" <#if customizedProduct.substation == '宁波'>selected</#if>>宁波</option>
		                    	<option value="常州" <#if customizedProduct.substation == '常州'>selected</#if>>常州</option>
		                    	<option value="嘉兴" <#if customizedProduct.substation == '嘉兴'>selected</#if>>嘉兴</option>
		                    	<option value="南通" <#if customizedProduct.substation == '南通'>selected</#if>>南通</option>
		                    	<option value="扬州" <#if customizedProduct.substation == '扬州'>selected</#if>>扬州</option>
		                    	<option value="镇江" <#if customizedProduct.substation == '镇江'>selected</#if>>镇江</option>
		                    	<option value="绍兴" <#if customizedProduct.substation == '绍兴'>selected</#if>>绍兴</option>
		                    	<option value="温州" <#if customizedProduct.substation == '温州'>selected</#if>>温州</option>
		                    	<option value="金华" <#if customizedProduct.substation == '金华'>selected</#if>>金华</option>
		                    	<option value="台州" <#if customizedProduct.substation == '台州'>selected</#if>>台州</option>
		                    	<option value="盐城" <#if customizedProduct.substation == '盐城'>selected</#if>>盐城</option>
		                    	<option value="青岛" <#if customizedProduct.substation == '青岛'>selected</#if>>青岛</option>
		                    	<option value="泰安" <#if customizedProduct.substation == '泰安'>selected</#if>>泰安</option>
		                    	<option value="芜湖" <#if customizedProduct.substation == '芜湖'>selected</#if>>芜湖</option>
		                    	<option value="黄山" <#if customizedProduct.substation == '黄山'>selected</#if>>黄山</option>
		                    	<option value="阜阳" <#if customizedProduct.substation == '阜阳'>selected</#if>>阜阳</option>
		                    	<option value="福州" <#if customizedProduct.substation == '福州'>selected</#if>>福州</option>
		                    	<option value="沈阳" <#if customizedProduct.substation == '沈阳'>selected</#if>>沈阳</option>
		                    	<option value="大连" <#if customizedProduct.substation == '大连'>selected</#if>>大连</option>
		                    	<option value="哈尔滨" <#if customizedProduct.substation == '哈尔滨'>selected</#if>>哈尔滨</option>
		                    	<option value="长春" <#if customizedProduct.substation == '长春'>selected</#if>>长春</option>
		                    	<option value="齐齐哈尔" <#if customizedProduct.substation == '齐齐哈尔'>selected</#if>>齐齐哈尔</option>
		                    	<option value="延边" <#if customizedProduct.substation == '延边'>selected</#if>>延边</option>
		                    	<option value="广州" <#if customizedProduct.substation == '广州'>selected</#if>>广州</option>
		                    	<option value="深圳" <#if customizedProduct.substation == '深圳'>selected</#if>>深圳</option>
		                    	<option value="香港" <#if customizedProduct.substation == '香港'>selected</#if>>香港</option>
		                    	<option value="澳门" <#if customizedProduct.substation == '澳门'>selected</#if>>澳门</option>
		                    	<option value="长沙" <#if customizedProduct.substation == '长沙'>selected</#if>>长沙</option>
		                    	<option value="南宁" <#if customizedProduct.substation == '南宁'>selected</#if>>南宁</option>
		                    	<option value="桂林" <#if customizedProduct.substation == '桂林'>selected</#if>>桂林</option>
		                    	<option value="武汉" <#if customizedProduct.substation == '武汉'>selected</#if>>武汉</option>
		                    	<option value="洛阳" <#if customizedProduct.substation == '洛阳'>selected</#if>>洛阳</option>
		                    	<option value="郑州" <#if customizedProduct.substation == '郑州'>selected</#if>>郑州</option>
		                    	<option value="海口" <#if customizedProduct.substation == '海口'>selected</#if>>海口</option>
		                    	<option value="三亚" <#if customizedProduct.substation == '三亚'>selected</#if>>三亚</option>
		                    	<option value="张家界" <#if customizedProduct.substation == '张家界'>selected</#if>>张家界</option>
		                    	<option value="珠海" <#if customizedProduct.substation == '珠海'>selected</#if>>珠海</option>
		                    	<option value="成都" <#if customizedProduct.substation == '成都'>selected</#if>>成都</option>
		                    	<option value="重庆" <#if customizedProduct.substation == '重庆'>selected</#if>>重庆</option>
		                    	<option value="昆明" <#if customizedProduct.substation == '昆明'>selected</#if>>昆明</option>
		                    	<option value="丽江" <#if customizedProduct.substation == '丽江'>selected</#if>>丽江</option>
		                    	<option value="大理" <#if customizedProduct.substation == '大理'>selected</#if>>大理</option>
		                    	<option value="西双版纳" <#if customizedProduct.substation == '西双版纳'>selected</#if>>西双版纳</option>
		                    	<option value="香格里拉" <#if customizedProduct.substation == '香格里拉'>selected</#if>>香格里拉</option>
		                    	<option value="贵阳" <#if customizedProduct.substation == '贵阳'>selected</#if>>贵阳</option>
		                    	<option value="拉萨" <#if customizedProduct.substation == '拉萨'>selected</#if>>拉萨</option>
		                    	<option value="西安" <#if customizedProduct.substation == '西安'>selected</#if>>西安</option>
		                    	<option value="银川" <#if customizedProduct.substation == '银川'>selected</#if>>银川</option>
		                    	<option value="西宁" <#if customizedProduct.substation == '西宁'>selected</#if>>西宁</option>
		                    	<option value="乌鲁木齐" <#if customizedProduct.substation == '乌鲁木齐'>selected</#if>>乌鲁木齐</option>
		                    </select>
	                    </td>
	                </tr>
	                 <tr>
						<td class="e_label">产品经理推荐：</td>
						<td>
							<textarea  name="managerRec"  rows="3"  maxlength="1500"  style="width:500px">${customizedProduct.managerRec!''}</textarea>
	                    </td>
	                </tr>
                	</tbody>
                </table>
            </div>
        </div>
        
        <div class="p_box box_info p_line">
		 	  <div class="title">
			   <h2 class="f16">关联</h2>
			  </div>
			  <div class="box_content">
                <table class="e_table form-inline">
                    <tbody>
		        	<#if customizedProduct.customizedProdDestReList?? && (customizedProduct.customizedProdDestReList?size &gt; 0)>
		                <#list customizedProduct.customizedProdDestReList as prodDestRe>
			                <tr <#if prodDestRe_index=0>name='no1'</#if>>
			                	<#if prodDestRe_index=0>
						   			<td name="addspan" rowspan='${customizedProduct.customizedProdDestReList?size}' class="e_label">目的地：</td>
						   		</#if>
					            <td>
					            	<input type="text" name="dest" class="w35" id="dest_${prodDestRe_index}" value="${prodDestRe.destName}" data="${prodDestRe.destId}" readonly = "readonly"  >
					            	<input type="hidden" name="customizedProdDestReList[${prodDestRe_index}].destId" id="destId${prodDestRe_index}" value="${prodDestRe.destId}"> <#if prodDestRe_index gt 0 >  <a class='btn btn_cc1' name='del_button'>删除</a></#if>
					            	<input type="hidden" name="customizedProdDestReList[${prodDestRe_index}].reId" id="reId" value="${prodDestRe.reId}">
					            	<input type="hidden" name="customizedProdDestReList[${prodDestRe_index}].productId" value="${customizedProduct.customizedProdId}">
					            	<#if prodDestRe_index=0><a class="btn btn_cc1" id="new_button">添加目的地</a></#if>
					            </td>
			        	    </tr>
	                	</#list>
                	<#else>    
		        		<tr name='no1'>
					   	   <td name="addspan" width="150" class="e_label">目的地：</td>
				           <td>
		                    	<input type="text" class="w35" id="dest_0" name="dest" readonly = "readonly" >
		                    	<input type="hidden" name="customizedProdDestReList[0].destId" id="destId0" /><a class="btn btn_cc1" id="new_button">添加</a>
		                    	<div id="addDestError"></div>
		                    	</br>
		                    	<div id="destDiv"></div>
		                    </td>
		        	    </tr>
                	</#if> 
                	</tbody>
                </table>
            </div>

</form>
</div>
<div class="fl operate" style="margin:20px;"><a class="btn btn_cc1" id="save">保存</a><a class="btn btn_cc1" id="saveAndNext">保存并维护下一步</a></div>
<#include "/base/foot.ftl"/>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/kindeditor.js"></script>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/plugins/image/image.js"></script>
<script type="text/javascript" src="/vst_admin/js/contentManage/kindEditorConf.js?v1"></script>
</body>
</html>
<script>
	$(document).ready(function(){
	
	
	
	var price = $("input[name='price1']:checked").val();
		if(price=='SJ') {
			$("#priceNum").show();
		} else {
			$("#priceNum").hide();
		}
	});
	$("input[name='price1']").change(function() {
		var price = $("input[name='price1']:checked").val();
		if(price == 'YTYY') {
			$("#priceNum").hide();
			$("#priceNum").val("");
		} 
		if(price=='SJ') {
			$("#priceNum").show();
			$("#priceNum").val("");
			
		}
	});
	
			var dests = ',';//子页面选择项对象数组
var count =0;
var markDest;
var markDestId;

//编辑页加载时先累计已有的目的地ID
$("input[name='dest']").each(function(){
	markDestId = $(this).next().attr("id");
 	if($('#'+ markDestId).val()!=""){
 		if(dests == ","){
 			dests = $('#'+ markDestId).val();
 		}else{
 			dests = dests + "," + $('#'+ markDestId).val();
 		}
 	}
});
	
//选择目的地
function onSelectDest(params){
	if(params!=null){
		var destId = params.destId;
		dests = "";
		for(var i = 0; i < 80; i++){
			if($("#destId"+i) != null){
				if(typeof($("#destId"+i).val()) !="undefined"){
					 dests = dests + ',' + $("#destId"+i).val();
				}
			}
		}
		if((dests+',').indexOf(','+destId+',')==0 || (dests+',').indexOf(','+destId+',')> 0 )
		{
		    alert('目的地已经存在');
		    return;
		}else{
			dests = dests + ',' + destId;
		}
		$("#"+markDest).val(params.destName);
		$("#"+markDestId).val(destId);
	}
	destSelectDialog.close();
}
		
		//新建目的地
$("#new_button").live("click",function(){
	count++;
	var rows = $("input[name=dest]").size();
	$("td[name=addspan]").attr("rowspan",rows+1);
	var $tbody = $(this).parents("tbody");
	$tbody.append("<tr><td><input type='text' class='w35' name='dest' id='dest_"+rows+"' readonly = 'readonly' required='true' /><input type='hidden' name='customizedProdDestReList["+rows+"].destId' id='destId"+rows+"'/><input type='hidden' name='customizedProdDestReList["+rows+"].productId' value='${customizedProduct.customizedProdId}'/>&nbsp;<a class='btn btn_cc1' name='del_button'>删除</a></td></tr>"); 
});

//删除目的地
$("a[name=del_button]").live("click",function(){
	if($(this).parents("tr").attr("name")=="no1"){
		$(this).parents("tr").find("input").val("");
		$(this).parents("tr").find("input").attr("data","");
		$("#dest").val("");
	}else{
		$(this).parents("tr").remove();
	}
	$(this).parents("tr").remove();
	var rows = $("input[name=dest]").size();
	$("td[name=addspan]").attr("rowspan",rows);
});

//打开选择行政区窗口
$("input[name=dest]").live("click",function(){
	markDest = $(this).attr("id");
	var idValue = markDest.split('_')[1];
	markDestId = 'destId'+idValue;
	var url = "/vst_admin/biz/dest/selectDestList.do?type=main";
	destSelectDialog = new xDialog(url,{},{title:"选择目的地",iframe:true,width:"1000",height:"600"});
});
refreshSensitiveWord($("input[type='text'],textarea"));
	
	<!-- 新增和原有script间隔 -->

var dictSelectDialog;//标准产品中动态加载中Input_type_select的对话框
var busiSelectIndex;//酒店业务字典

	var districtSelectDialog,contactAddDialog,coordinateSelectDialog;
	
	var dataObj=[],markList=[];
	
	$(".sensitiveVad").each(function(){
		var mark=$(this).attr('mark');
	 	var t = lvmamaEditor.editorCreate('mark',mark);
	 	dataObj.push(t);
	 	markList.push(mark);
	});
	
	 
	$("#save").click(function(){
		var propPerson0 = parseInt($("#propPerson0").val());
		var propPerson1 = parseInt($("#propPerson1").val());
		
		if($("#propPerson0").val() =='' && $("#propPerson1").val() == '') {
			$("#spanPropPerson").html("适合人数不能为空");
			$("#spanPropPerson").css("color","red");
			return false;
		} else {
			$("#spanPropPerson").html("");
		}
			
		var reg = new RegExp("^[0-9]*$"); 
		  if($("#propPerson0").val() != '' && !reg.test(propPerson0)){  
       			$("#spanPropPerson").html("请输入正确数字");
				$("#spanPropPerson").css("color","red");
				return false;
   		 }  
		 if($("#propPerson1").val() != ''  && !reg.test(propPerson1)){  
       			$("#spanPropPerson").html("请输入正确数字");
				$("#spanPropPerson").css("color","red");
				return false;
   		 }  
		
		if($("#propPerson0").val() != '' && $("#propPerson1").val() != '') {
			if(propPerson0 > propPerson1) {
				 $("#spanPropPerson").html("前一个人数不能大于后一个人数");
				 $("#spanPropPerson").css("color","red");
				 return false;
			}
		}
			
			
		for(var i=0;i<dataObj.length;i++){
			var temp = dataObj[i].html();
			$(".sensitiveVad").filter("[mark="+markList[i]+"]").text(temp);
		}
	
		$.each( $("input[autoValue='true']"), function(i, n){
			if($(n).val()==""){
				$(n).val($(n).attr('placeholder'));
			}
		}); 
		
		
		$("textarea").not(".ckeditor").each(function(){
			if($(this).text()==""){
				$(this).text($(this).attr('placeholder'));
			}
		});
		
		if(!$("#dataForm").validate({
			rules : {
				productName : {
					isChar : true
				}
					},
			messages : {
				productName : '不可为空或者特殊字符'
				
			}
		}).form()){
					$(this).removeAttr("disabled");
					return false;
		}
		
		
		 var msg = '确认保存吗 ？';	
		 if(refreshSensitiveWord($("input[type='text'],textarea"))){
		 	$("input[name=senisitiveFlag]").val("Y");
		 	msg = '内容含有敏感词,是否继续?'
		 }else {
	 		 $("input[name=senisitiveFlag]").val("N");
		 }
		 
		 $("#save").hide();
		 $("#saveAndNext").hide();
		 $.confirm(msg,function(){
			//遮罩层
			var loading = top.pandora.loading("正在努力保存中...");		
			$.ajax({
				url : "/vst_admin/prod/customized/updateProduct.do",
				type : "post",
				dataType : 'json',
				data : $("#dataForm").serialize(),
				success : function(result) {
					loading.close();
					if(result.code == "success"){
						//为子窗口设置productId
						$("input[name='productId']").val(result.attributes.productId);
						//为父窗口设置productId
						$("#productId",window.parent.document).val(result.attributes.productId);
						//$("#productName",window.parent.document).val(result.attributes.productName);
						//$("#categoryName",window.parent.document).val(result.attributes.categoryName);
						pandora.dialog({wrapClass: "dialog-mini", content:result.message, mask:true,okValue:"确定",ok:function(){
						$(".pg_title", parent.document).html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("input[name='productName']").val()+"   "+"产品ID："+$("input[name='productId']").val());
						parent.checkAndJump();
						}});
					}else {
						$.alert(result.message);
						$("#save").show();
						$("#saveAndNext").show();
					}
				},
				error : function(){
					$("#save").show();
					$("#saveAndNext").show();
					loading.close();
				}
			})
		},function(){
			$("#save").show();
			$("#saveAndNext").show();
		});
	});
	 
	$("#saveAndNext").click(function(){
		$.each( $("input[autoValue='true']"), function(i, n){
			if($(n).val()==""){
				$(n).val($(n).attr('placeholder'));
			}
		}); 
		
	 
		$(".ckeditor").each(function(){
			var that = $(this);
			$.each(CKEDITOR.instances, function(i, n){
					if(that.attr('name')==n.name){
		    			if(n.getData()==""){
							that.text(that.attr('placeholder'));
						}else{
							that.text(n.getData());
						}
						if(that.attr("data")=="Y"){
								that.attr("required",true);
								that.show();
						}
		    		}
			});
		});
		$("textarea").not(".ckeditor").each(function(){
			if($(this).text()==""){
				$(this).text($(this).attr('placeholder'));
			}
		});
		if(!$("#dataForm").validate({
			rules : {
				productName : {
					isChar : true
				}
					},
			messages : {
				productName : '不可输入特殊字符'
				
			}
		}).form()){
				return false;
			}
			
		var propPerson0 = parseInt($("#propPerson0").val());
		var propPerson1 = parseInt($("#propPerson1").val());
		
		if($("#propPerson0").val() =='' && $("#propPerson1").val() == '') {
			$("#spanPropPerson").html("适合人数不能为空");
			$("#spanPropPerson").css("color","red");
			return false;
		} else {
			$("#spanPropPerson").html("");
		}
			
		var reg = new RegExp("^[0-9]*$"); 
		  if($("#propPerson0").val() != '' && !reg.test(propPerson0)){  
       			$("#spanPropPerson").html("请输入正确数字");
				$("#spanPropPerson").css("color","red");
				return false;
   		 }  
		 if($("#propPerson1").val() != ''  && !reg.test(propPerson1)){  
       			$("#spanPropPerson").html("请输入正确数字");
				$("#spanPropPerson").css("color","red");
				return false;
   		 }  
		
		if($("#propPerson0").val() != '' && $("#propPerson1").val() != '') {
			if(propPerson0 > propPerson1) {
				 $("#spanPropPerson").html("前一个人数不能大于后一个人数");
				 return false;
			}
		}
		
		 var msg = '确认保存吗 ？';	
		 if(refreshSensitiveWord($("input[type='text'],textarea"))){
		 	$("input[name=senisitiveFlag]").val("Y");
		 	msg = '内容含有敏感词,是否继续?'
		 }else {
			 		 $("input[name=senisitiveFlag]").val("N");
		 }
		 $("#save").hide();
		 $("#saveAndNext").hide();
		 $.confirm(msg,function(){
			var loading = top.pandora.loading("正在努力保存中...");
			//刷新AddValue的值		
			refreshAddValue();
			//遮罩层
			$.ajax({
				url : "/vst_admin/prod/customized/updateProduct.do",
				type : "post",
				dataType : 'json',
				data : $("#dataForm").serialize(),
				success : function(result) {
					loading.close();
					if(result.code == "success"){
						//为子窗口设置productId
						$("input[name='productId']").val(result.attributes.productId);
						//为父窗口设置productId
						$("#productId",window.parent.document).val(result.attributes.productId);
						//$("#productName",window.parent.document).val(result.attributes.productName);
						//$("#categoryName",window.parent.document).val(result.attributes.categoryName);					
						pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
							var productId = result.attributes.productId;
							$("#productDetail",parent.document).parent("li").trigger("click");
							//window.location = "/vst_admin/prod/customizedProdDetail/showAddOrUpdateProductDetail.do?productId="+productId;
						}});
						$(".pg_title", parent.document).html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("input[name='productName']").val()+"   "+"产品ID："+$("input[name='productId']").val());
					}else {
						$.alert(result.message);
						$("#save").show();
						$("#saveAndNext").show();
					}
				},
				error : function(){
					loading.close();
					$("#save").show();
					$("#saveAndNext").show();
				}
			});
		},function(){
			$("#save").show();
			$("#saveAndNext").show();
		});
	});
		
	function showAddFlagSelect(params,index){
		if($(params).find("option:selected").attr('addFlag') == 'Y'){
			var StrName = document.getElementsByName("prodProductPropList["+index+"].addValue")
			if($(StrName).size()==0){
				$(params).after("<input type='text' style='width:120px' data='"+$(params).val()+"' alias='prodProductPropList["+index+"].addValue' remark='remark'>");
			}
		}else{
			$(params).next().remove();
		}
	}
</script>