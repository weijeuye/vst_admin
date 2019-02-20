<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>

<body>
	<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">首页</a> &gt;</li>
            <li><a href="#">第二出发地</a> &gt;</li>
            <li class="active">第二出发地列表</li>
        </ul>
	</div>
	<div class="iframe_content mt10">
		<div class="p_box box_info p_line">
			<div id="price_tab" class="price_tab">
				<ul class="J_tab ui_tab">		
					<li id="district"><a href="javascript:;">出发地</a></li>
					<li id="dest"><a href="javascript:;">目的地</a></li>
				</ul>
			</div>            
		</div>
		<div class="districtAround" id="districtAround" style="height:1000px;width:1300px">
		</div>
	</div>	
	<#include "/base/foot.ftl"/>
</body>
</html>

<script>
	$(function(){
		
		showPage($("#district"));
	});
	
	$("#price_tab ul li").click(function(e) {
	        showPage($(this));
	    });
	    
	    
	 function refreashTab(url,param){
	
		$.post(url,param,function(data){
			$("#districtAround").html(data);
		});
	}   
	    
	    
	function showPage(obj){
		$("#districtAround").html("");
		var url = ''; 
		var id = obj.attr('id');
		if(id=='dest'){
			url = "/vst_admin/front/destAround/findDestLists.do"
		}else{
			url = "/vst_admin/front/districtAround/findDistrictList.do"
		}
		obj.attr('class','active');
		$("#price_tab ul li").each(function(){
			$(this).not(obj).attr('class','');
		});
		
		//refreashTab(url,"");
		var iframe = "<iframe id=\"main\" class=\"iframeID\" src=\""+url+"\" style=\"width:90%;height:100%\" frameborder=\"no\" scrolling=\"auto\"/>";
		$("#districtAround").append(iframe);
		$("#main").load();
	
	}
	
	
	
</script>
	
