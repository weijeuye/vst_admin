<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>

<body>
	<div class="iframe_content mt10" style="height:660px;">
		<input type="hidden" value="${dest.destId}" id="destId"/>
		<input type="hidden" value="${showTab}" id="showTab"/>
		<input type="hidden"  id="disrtId"/>
		 <div class="title">
		     <h2 class="f16">当前目的地：${dest.destName!''}</h2>
		 </div>
		<div class="p_box box_info p_line">
			<div id="price_tab" class="price_tab,main-navigation">
				<ul class="J_tab ui_tab" style="height: 82px;">
					<#if oders??>
						<#list oders as order>
							<#if order!='HOTELCOMB'>
							<li id="${order}" subId=""><a href="javascript:;">${order.cnName}</a>
								<#if order == 'FREETOUR' && FREETOUR??>
									<!-- FREETOUR -->
									<ul id='ul_${order}' style="display: none;">
										<#list FREETOUR as tmp>
											<li id="${order}" subId="${tmp.categoryId}"><a href="javascript:;">${tmp.categoryName}</a></li>
										</#list>
									</ul>
								</#if>
							</li>
							</#if>
						</#list>
					</#if>
				</ul>
			</div>            
		</div>
		<div class="destAdvertising" id="destAdvertising">
		</div>
	</div>	
	<#include "/base/foot.ftl"/>
</body>
</html>

<script>
	$(function(){
		var showTabValue = $('#showTab').val();
		if(showTabValue != ""){
			var obj = $('#' + showTabValue);
		}else{
			var obj = $('#ALL');
		}
		showPage(obj);
		
	});
	//绑定点击事件
	$("#price_tab ul li").click(function(e) {
        showPage($(this));
    });
	$("#price_tab ul li ul li").click(function(e) {
        showChilrenPage($(this), e);
    });
	//绑定鼠标悬浮事件
	$("#price_tab ul li").mouseover(function(e) {
        showChildrenTab($(this));
    });
	$("#price_tab ul li").mouseout(function(e) {
        hideChildrenTab($(this));
    });
    
	//显示tab的子tab
	function showChildrenTab(obj) {
		var id = obj.attr('id');
		if (document.getElementById('ul_'+id)) {
			$("#ul_"+id).show();
		}
	}
	function hideChildrenTab(obj) {
		var id = obj.attr('id');
		if (document.getElementById('ul_'+id)) {
			if ($("#ul_"+id).find(".active") && $("#ul_"+id).find(".active").length == 0) {
				$("#ul_"+id).hide();
			}
		}
		
	}
	
	function showPage(obj){
		var id = obj.attr('id');
		if (document.getElementById('ul_'+id)) {
			return;
		}
		$("#ul_FREETOUR").hide();
		$("#destAdvertising").html("");
	    var destId = $("#destId").val();
		var distrId = $("#disrtId").val();
		var url = ''; 
		if(destId.length <= 0){
			obj = $('#ALL');
		}
		
		//酒+景 子品类id
		var subId = obj.attr('subId');
		
		if(id != null && typeof id != "undefined" && obj.length != 0){
			url = getUrl(destId,distrId,id, subId);
		}else{
			url = getUrl(destId,distrId,'ALL');
			$('#showTab').val("ALL");
		}
		obj.attr('class','active');
		
		$("#price_tab ul li").each(function(){
			
			$(this).not(obj).attr('class','');
		});
		
		
		var iframe = "<iframe id=\"main\" class=\"iframeID\" src=\""+url+"\" width=\"1000\" height=\"550\" frameborder=\"no\" scrolling=\"auto\"/>";
		$(".destAdvertising").append(iframe);
		
		$("#main").load();
		$('#disrtId').val("");
			
	}
	//显示酒+景品类广告列表
	function showChilrenPage(obj, e){
		stopPropagation(e);
		$("#destAdvertising").html("");
	    var destId = $("#destId").val();
		var distrId = $("#disrtId").val();
		var url = ''; 
		if(destId.length <= 0){
			obj = $('#ALL');
		}
		
		var id = obj.attr('id');
		//酒+景 子品类id
		var subId = obj.attr('subId');
		
		if(id != null && typeof id != "undefined" && obj.length != 0){
			url = getUrl(destId,distrId,id, subId);
		}else{
			url = getUrl(destId,distrId,'ALL');
			$('#showTab').val("ALL");
		}
		obj.attr('class','active');
		
		$("#price_tab ul li").each(function(){
			
			$(this).not(obj).attr('class','');
		});
		
		
		var iframe = "<iframe id=\"main\" class=\"iframeID\" src=\""+url+"\" width=\"900\" height=\"550\" frameborder=\"no\" scrolling=\"auto\"/>";
		$(".destAdvertising").append(iframe);
		
		$("#main").load();
		$('#disrtId').val("");
			
	}
	
	function clickTab(showTabValue,disrtId, subId){
		$('#disrtId').val(disrtId);
		if (showTabValue == 'FREETOUR') {
			$('#'+showTabValue+' [subId="'+subId+'"]').trigger("click");
		} else {
			$('#'+showTabValue).trigger("click");
		}
		
	}
	
	function getUrl(destId,distrId,type,subId){
		var url = '/vst_admin/front/destAdvertising/showEditDestAdvertising.do?destId='+destId+'&showTab='+type+'&distrId='+distrId+'&subId='+subId;
		$('#showTab').val(type);
		return url;
	}
	
	function stopPropagation(e) {
		//如果提供了事件对象，则这是一个非IE浏览器
		if ( e && e.stopPropagation ) {
			//因此它支持W3C的stopPropagation()方法
			e.stopPropagation(); 
		} else {
			//否则，我们需要使用IE的方式来取消事件冒泡 
			window.event.cancelBubble = true;
		}
	}
</script>
