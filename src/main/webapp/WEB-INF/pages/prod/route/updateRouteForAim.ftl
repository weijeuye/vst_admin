
<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body >
<div class="iframe_search">
<form method="post"   id="dataForm">
    <table class="s_table">
			<tr>
			 	<td class="e_label"><i class="cc1">*</i>行程名称：</td>
                <td class="w15">
                    <input type="text" class="w35" name="routeName" value="${prodLineRoute.routeName!''}"  id="routeName" maxlength="30" readonly = "readonly" >
                    <input type="hidden" id="categoryCode" value="${prodProduct.bizCategory.categoryCode}"/>
                </td>
            </tr>
           <tr>
                    <td class="e_label"><i class="cc1">*</i>行程天数：</td>
                    <td>
                       <label>
                         <input type="text"  name="routeNum" id="routeNum"   
					     <#if routeChangeAble=="N" >readonly="readonly"</#if>    number="true" maxlength="4" value="${prodLineRoute.routeNum !''}"/>天
                       </label>
					<#if prodProduct.bizCategory.categoryCode == 'category_route_group' || prodProduct.bizCategory.categoryCode == 'category_route_freedom' || prodProduct.bizCategory.categoryCode == 'category_route_customized'>
                        <input type="checkbox"  name="trafficNumFlag"  id="trafficNumFlag" <#if prodLineRoute.trafficNum!=0>checked</#if>/>航班原因：
						<select name="trafficNum" id="trafficNum" <#if prodLineRoute.trafficNum != '1' && prodLineRoute.trafficNum != '-1'>disabled</#if> >
							<option value="1" <#if prodLineRoute.trafficNum == '1'>selected</#if>>+1天</option>
							<option value="-1" <#if prodLineRoute.trafficNum == '-1'>selected</#if>>-1天</option>
							<option value="2" <#if prodLineRoute.trafficNum == '2'>selected</#if>>+2天</option>
                        </select>
                        <input type="hidden" id="trafficNumVal" value="0"/>
					</#if>
                        <div id="routeNum"></div>
                    </td>
                </tr>
                <tr>
                    <td class="e_label"><i class="cc1">*</i>入住几晚：</td>
                    <td><label>
                        <input type="text" name="stayNum" id="stayNum"   <#if  routeChangeAble=="N">readonly="readonly"</#if> required=true number="true" maxlength="4"   value="${prodLineRoute.stayNum!'' }"/>晚
                        <div id="stayNumError"></div>
                    </label>
                    </td>
                </tr>
			<tr>
			 	<td class="e_label">行程特色：</td>
                <td class="w35">
                    <textarea class="w35 textWidth" style="width: 360px; height: 30px;"  id="routeFeature" name="routeFeature" required maxlength=100>${prodLineRoute.routeFeature!''}</textarea>
                    <input type="hidden" name="productId" value="${prodProduct.productId!''}">
                    <input type="hidden" name="lineRouteId" value="${prodLineRoute.lineRouteId!''}">
                </td>
            </tr> 
             <tr>
               <td  ><a class="btn btn_cc1" id="save">保存</a> </td>
            </tr>
		</table>
	</form>
</div>

</html>

<script>

//校验行程天数、入住晚数
 function validateRouteNum(){
		var validateFlag = true;
		//正整数
		var integerReg1 = /^[1-9]*[1-9][0-9]*$/;
		var routeNum = $("#routeNum").val();
		var stayNum = $("#stayNum").val();		
		if(routeNum != null && routeNum != '' ){
			if(!integerReg1.test(routeNum)){
				alert("请输入正确的行程天数(数字>0)");
				validateFlag = false;
			}
		}else{
		     alert("行程天数必填");
		     validateFlag = false;
		}
		var integerReg2 = /^(0|[1-9]\d*)$/;
		if(stayNum != null && stayNum != '' ){
			if(!integerReg2.test(stayNum)){
				alert("请输入正确的入住晚数(数字>=0)");
				validateFlag = false;
			}
		}else{
		    var categoryCode = $("#categoryCode").val();
		 	if(categoryCode!= 'category_route_local'){
		 	 alert("入住晚数必填");
		     validateFlag = false;
		    }
		}
		return validateFlag;
  }
  
     $("#trafficNumFlag").click(function(){
		onSelectTrafficNum();
	});
  
   //选择航班原因必须选择天数
	function onSelectTrafficNum(){
		if($("#trafficNumFlag").prop("checked")){
			$("#trafficNum").removeAttr("disabled");
            $("#trafficNumVal").removeAttr("name");
		}else{
            $("#trafficNumVal").attr("name","trafficNum");
			$("#trafficNum").attr("disabled","disabled");
		}
	}
	
	
	 //保存
  $("#save").click(function(){
     var routeName=$("#routeName").val();
     if(routeName==null||routeName=='') {
          alert("行程名称不能为空");
          return false;
     }
     if(validateRouteNum()){
       var loading = top.pandora.loading("正在努力保存中...");
       	$.ajax({
					url : "/vst_admin/prod/prodLineRoute/addProdLineRoute.do",
					type : "post",
					dataType : 'json',
					data :  $("#dataForm").serialize(),
					success : function(result) {
					        loading.close();
		   				    parent.confirmAndRefresh(result);
		   				    parent.docSelectDialog.close(); 
					}
					,
					error : function(){
						loading.close();
					}
				});
				
     }
  });
	
	 //行程特色字数校验
  $(".textWidth").keyup(function() {
				var wordsLenth = $(this).attr("maxlength") - $(this).val().length;
				$(this).siblings("#textWidthTip").remove();
				countLenth($(this));
  });
  
	  function  countLenth(id) {
			var realLength = 0;
		    var len = id.val().length;
		    var charCode = -1;
		    var maxlen = 0;
		    for(var i = 0; i < len; i++){
		    	if(realLength<=id.attr("maxlength")){
			        charCode = $(id).val().charCodeAt(i);
			        if (charCode >= 0 && charCode <= 128) { 
			            realLength += 1;
			        }else{ 
			            // 如果是中文则长度加3
			            realLength += 2;
			        }
		        }
		    	if(realLength<=id.attr("maxlength")){
		    		maxlen = maxlen+1;
		    	}
		    } 
			var wordsLenth = id.attr("maxlength") - realLength;
			id.siblings("#textWidthTip").remove();
			if(wordsLenth<0){
				id.val(id.val().substring(0,maxlen));
				wordsLenth=0;
			}
			id.after("<span id = 'textWidthTip'>还能输入" + parseInt(wordsLenth/2) + "个汉字或者"+wordsLenth+"个字母</span>");
		}	
</script>