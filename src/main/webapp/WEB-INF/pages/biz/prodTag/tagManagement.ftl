<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body>
	<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">首页</a> &gt;</li>
            <li><a href="#">标签与主题</a> &gt;</li>
            <li class="active">标签管理</li>
        </ul>
	</div>
 	<div class="price_tab"> 
        <ul class="J_tab ui_tab">   
            <li>
            	<a id="default_link" target="tabMain" name="tabChange" data=0>产品标签</a>
            </li>
            <li>
            	<a target="tabMain" name="tabChange" data=1>商品标签</a>
            </li>
            
             <li>
            	<a target="tabMain" name="tabChange" data=2>规格标签</a>
            </li>
            
            <@mis.checkPerm permCode="5631" permParentCode="3708">
            <li>
            	<a target="tabMain" name="tabChange" data=3>品牌标签</a>
            </li>
            </@mis.checkPerm >
            
         </ul>
     </div>
	 <input type="hidden" id="selectedTab" value="${selectedTab}"/>
	
	 <div id="tagContent" scrolling="auto">
	 	<iframe id="tabMain" name="tabMain" src="" frameborder="0" style=" width:100%; height:100%; background:#fff; min-height:820px;"></iframe>
	 </div>
	 
	 <#include "/base/foot.ftl"/>
	 
	 
	 <script>
		
	$(function() {
		
		$("a[name=tabChange]").click(function() {
			$(this).parent().addClass('active').siblings().removeClass();
			if($(this).attr("data")==0){
				url = '/vst_admin/biz/prodTag/showProdTagList.do?objectType=PROD_PRODUCT&tagGroup='+encodeURIComponent(encodeURIComponent('全部'));
			} else if($(this).attr("data")== 1) {
				url = '/vst_admin/biz/prodTag/showProdTagList.do?objectType=SUPP_GOODS&tagGroup='+encodeURIComponent(encodeURIComponent('全部'));
			} else if($(this).attr("data")== 2) {
				url = '/vst_admin/biz/prodTag/showProdTagList.do?objectType=PROD_PRODUCT_BRANCH&tagGroup='+encodeURIComponent(encodeURIComponent('全部'));
			} else if($(this).attr("data")== 3) {
				url = '/vst_admin/biz/prodTag/showProdTagList.do?objectType=PROD_PRODUCT&tagGroup='+encodeURIComponent(encodeURIComponent('品牌'))
			}
			$('#tabMain').attr('src', url);	
				
		});
		
		$('#default_link').click();
		
	});
	
	
		 
	</script>
</body>
</html>



