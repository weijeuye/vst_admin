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
            <li><a href="#">定制游产品管理</a> &gt;</li>
            <li class="active">产品列表</li>
        </ul>
</div>
    
    <div class="p_box box_info">
	<form method="post" action='/vst_admin/prod/customized/findProductList.do' id="searchForm">
        <table class="s_table">
            <tbody>
                <tr>
                    <td class="s_label">产品编号：</td>
                    <td class="w18"><input type="text" name="customizedProdId" value="${customizedProduct.customizedProdId!''}"  number="true" maxLength="11" ></td>
                    <td class="s_label">产品名称：</td>
                    <td class="w18"><input type="text" name="productName" value="${customizedProduct.productName!''}"></td>
                   <td class="s_label">上线状态：</td>
                    <td class="w18">
                    	<select name="cancelFlag">
                    		<option value="">全部</option>
			                    	<option value='Y' <#if cancelFlag== 'Y'>selected</#if>>上线</option>
			                    	<option value='N' <#if cancelFlag == 'N'>selected</#if>>下线</option>
                    	</select>
                    </td>
                    <td class="s_label">所属分站：</td>
                    <td class="w18">
                    	<select name="substation">
                    		<option value="">全部</option>
			                    	<option value="上海" <#if substation == '上海'>selected</#if>>上海</option>
		                    	<option value="无锡" <#if substation == '无锡'>selected</#if>>无锡</option>
		                    	<option value="北京" <#if substation == '北京'>selected</#if>>北京</option>
		                    	<option value="天津" <#if substation == '天津'>selected</#if>>天津</option>
		                    	<option value="唐山" <#if substation == '唐山'>selected</#if>>唐山</option>
		                    	<option value="呼和浩特" <#if substation == '呼和浩特'>selected</#if>>呼和浩特</option>
		                    	<option value="包头" <#if substation == '包头'>selected</#if>>包头</option>
		                    	<option value="石家庄" <#if substation == '石家庄'>selected</#if>>石家庄</option>
		                    	<option value="南京" <#if substation == '南京'>selected</#if>>南京</option>
		                    	<option value="杭州" <#if substation == '杭州'>selected</#if>>杭州</option>
		                    	<option value="合肥" <#if substation == '合肥'>selected</#if>>合肥</option>
		                    	<option value="厦门" <#if substation == '厦门'>selected</#if>>厦门</option>
		                    	<option value="济南" <#if substation == '济南'>selected</#if>>济南</option>
		                    	<option value="南昌" <#if substation == '南昌'>selected</#if>>南昌</option>
		                    	<option value="苏州" <#if substation == '苏州'>selected</#if>>苏州</option>
		                    	<option value="宁波" <#if substation == '宁波'>selected</#if>>宁波</option>
		                    	<option value="常州" <#if substation == '常州'>selected</#if>>常州</option>
		                    	<option value="嘉兴" <#if substation == '嘉兴'>selected</#if>>嘉兴</option>
		                    	<option value="南通" <#if substation == '南通'>selected</#if>>南通</option>
		                    	<option value="扬州" <#if substation == '扬州'>selected</#if>>扬州</option>
		                    	<option value="镇江" <#if substation == '镇江'>selected</#if>>镇江</option>
		                    	<option value="绍兴" <#if substation == '绍兴'>selected</#if>>绍兴</option>
		                    	<option value="温州" <#if substation == '温州'>selected</#if>>温州</option>
		                    	<option value="金华" <#if substation == '金华'>selected</#if>>金华</option>
		                    	<option value="台州" <#if substation == '台州'>selected</#if>>台州</option>
		                    	<option value="盐城" <#if substation == '盐城'>selected</#if>>盐城</option>
		                    	<option value="青岛" <#if substation == '青岛'>selected</#if>>青岛</option>
		                    	<option value="泰安" <#if substation == '泰安'>selected</#if>>泰安</option>
		                    	<option value="芜湖" <#if substation == '芜湖'>selected</#if>>芜湖</option>
		                    	<option value="黄山" <#if substation == '黄山'>selected</#if>>黄山</option>
		                    	<option value="阜阳" <#if substation == '阜阳'>selected</#if>>阜阳</option>
		                    	<option value="福州" <#if substation == '福州'>selected</#if>>福州</option>
		                    	<option value="沈阳" <#if substation == '沈阳'>selected</#if>>沈阳</option>
		                    	<option value="大连" <#if substation == '大连'>selected</#if>>大连</option>
		                    	<option value="哈尔滨" <#if substation == '哈尔滨'>selected</#if>>哈尔滨</option>
		                    	<option value="长春" <#if substation == '长春'>selected</#if>>长春</option>
		                    	<option value="齐齐哈尔" <#if substation == '齐齐哈尔'>selected</#if>>齐齐哈尔</option>
		                    	<option value="延边" <#if substation == '延边'>selected</#if>>延边</option>
		                    	<option value="广州" <#if substation == '广州'>selected</#if>>广州</option>
		                    	<option value="深圳" <#if substation == '深圳'>selected</#if>>深圳</option>
		                    	<option value="香港" <#if substation == '香港'>selected</#if>>香港</option>
		                    	<option value="澳门" <#if substation == '澳门'>selected</#if>>澳门</option>
		                    	<option value="长沙" <#if substation == '长沙'>selected</#if>>长沙</option>
		                    	<option value="南宁" <#if substation == '南宁'>selected</#if>>南宁</option>
		                    	<option value="桂林" <#if substation == '桂林'>selected</#if>>桂林</option>
		                    	<option value="武汉" <#if substation == '武汉'>selected</#if>>武汉</option>
		                    	<option value="洛阳" <#if substation == '洛阳'>selected</#if>>洛阳</option>
		                    	<option value="郑州" <#if substation == '郑州'>selected</#if>>郑州</option>
		                    	<option value="海口" <#if substation == '海口'>selected</#if>>海口</option>
		                    	<option value="三亚" <#if substation == '三亚'>selected</#if>>三亚</option>
		                    	<option value="张家界" <#if substation == '张家界'>selected</#if>>张家界</option>
		                    	<option value="珠海" <#if substation == '珠海'>selected</#if>>珠海</option>
		                    	<option value="成都" <#if substation == '成都'>selected</#if>>成都</option>
		                    	<option value="重庆" <#if substation == '重庆'>selected</#if>>重庆</option>
		                    	<option value="昆明" <#if substation == '昆明'>selected</#if>>昆明</option>
		                    	<option value="丽江" <#if substation == '丽江'>selected</#if>>丽江</option>
		                    	<option value="大理" <#if substation == '大理'>selected</#if>>大理</option>
		                    	<option value="西双版纳" <#if substation == '西双版纳'>selected</#if>>西双版纳</option>
		                    	<option value="香格里拉" <#if substation == '香格里拉'>selected</#if>>香格里拉</option>
		                    	<option value="贵阳" <#if substation == '贵阳'>selected</#if>>贵阳</option>
		                    	<option value="拉萨" <#if substation == '拉萨'>selected</#if>>拉萨</option>
		                    	<option value="西安" <#if substation == '西安'>selected</#if>>西安</option>
		                    	<option value="银川" <#if substation == '银川'>selected</#if>>银川</option>
		                    	<option value="西宁" <#if substation == '西宁'>selected</#if>>西宁</option>
		                    	<option value="乌鲁木齐" <#if substation == '乌鲁木齐'>selected</#if>>乌鲁木齐</option>
                    	</select>
                    </td>
                    <td class=" operate mt10">
	                	<a class="btn btn_cc1" id="search_button">查询</a> 
	                    <@mis.checkPerm permCode="5899"><a class="btn btn_cc1" id="new_button">新增</a></@mis.checkPerm>
                    </td>
                </tr>
            </tbody>
        </table>	
		</form>
	</div>
<!-- 主要内容显示区域\\ -->
    <#if pageParam??>
    <#if pageParam.items?? &&  pageParam.items?size &gt; 0>
    <div class="p_box box_info">
    <table class="p_table table_center">
                <thead>
                    <tr>
                    <th>产品编号</th>
                    <th>产品名称</th>
                    <th>所属主题</th>
                    <th>上线状态</th>
                    <th>分站</th>
                    <th>更新时间</th>
                    <th width="350px">操作</th>
                    </tr>
                </thead>
                <tbody>
					<#list pageParam.items as product> 
					<tr>
					<td>${product.customizedProdId!''} </td>
					<td>${product.productName!''} </td>
					<td>
						<#list product.prodSubjectList as prodSubject> 
							${prodSubject.bizSubject.subjectName} 
						</#list>
					</td>
					<td>
						<#if product.cancelFlag == "Y"> 
						<span style="color:green">上线</span>
						<#else>
						<span style="color:red">下线</span>
						</#if>
					</td>
					<td>${product.substation!''} </td>
					<td>${product.updateTime?string('yyyy-MM-dd HH:mm:ss')} </td>
					<td class="oper">
						<@mis.checkPerm permCode="5897"><a href="http://www.lvmama.com/vst_front/customized/${product.customizedProdId}/preview" target="_blank" >预览</a></@mis.checkPerm>
                        <@mis.checkPerm permCode="5898"><a href="javascript:void(0);" class="editProd" data="${product.customizedProdId}">编辑</a></@mis.checkPerm>
                            <a href="javascript:void(0);" class="showLogDialog" param='objectId=${product.customizedProdId!''}&objectType=CUSTOMIZED_PRODUCT&sysName=VST'>操作日志</a> 
                            <#if product.cancelFlag == "Y"> 
                            <a href="javascript:void(0);" class="cancelProd" productName=${product.productName} data="N" productId=${product.customizedProdId}>下线</a>
                            <#else>
                            <a href="javascript:void(0);" class="cancelProd" data="Y" productName=${product.productName} productId=${product.customizedProdId}>上线</a>
                             </#if>
                        </td>
					</tr>
					</#list>
                </tbody>
            </table>
				<#if pageParam.items?exists> 
					<div class="paging" > 
					${pageParam.getPagination()}
						</div> 
				</#if>
        
	</div><!-- div p_box -->
	<#else>
		<div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div>
    </#if>
    </#if>
<div id="showProductTargetBox"  style="display:none;padding:10px; border:1px solid #FF8801; background-color:#FFFFE0;overflow:auto;max-height:200px;">
</div>
<!-- //主要内容显示区域 -->
</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
vst_pet_util.commListSuggest("#supplierName", "#supplierId",'/vst_back/supp/supplier/searchSupplierList.do','${suppJsonList}');
var categorySelectDialog;

$(function(){
<@mis.checkPerm permCode="3525" >
//如果是仅查看权限，则移除编辑
//$("a.editProd").remove();
//$("a.cancelProd").remove();
</@mis.checkPerm >

//产品规格
	$("a.prodBranch").bind("click",function(){
		var productId = $(this).attr("data");
		var categoryId = $(this).attr("data_catId");
		window.location.href="/vst_admin/prod/prodbranch/findProductBranchList.do?productId="+productId+"&categoryId="+categoryId;
	});

	//查询
	$("#search_button").bind("click",function(){
		if(!$("#searchForm").validate().form()){
				return false;
			}
		$(".iframe-content").empty();
		$(".iframe-content").append("<div class='loading mt20'><img src='../../img/loading.gif' width='32' height='32' alt='加载中'> 加载中...</div>");
		//去掉左右的空格
		$("input[name=productName]").val( $.trim($("input[name=productName]").val()));
        $("input[name=productId]").val( $.trim($("input[name=productId]").val()));
        $("input[name=goodsId]").val( $.trim($("input[name=goodsId]").val()));
        $("input[name=suppProductName]").val( $.trim($("input[name=suppProductName]").val()));
        $("#districtName").val( $.trim($("#districtName").val()));

		$("#searchForm").submit();
	});
	
	//新建
	$("#new_button").bind("click",function(){
		//打开弹出窗口
		window.open("/vst_admin/prod/customized/showProductMaintain.do");
		return;
	});
	
	//修改
	$("a.editProd").bind("click",function(){
		var productId = $(this).attr("data");
		window.open("/vst_admin/prod/customized/toUpdateProduct.do?productId="+productId);
		return false;
	});
	
	
	//查看
	$("a.viewProd").bind("click",function(){
		var productId = $(this).attr("data");
		var categoryId = $(this).attr("data1");
		var categoryName = $(this).attr("categoryName");
		window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&isView=Y&categoryId="+categoryId+"&categoryName="+categoryName);
		return false;
	});

	//设置为预览
	function preview(categoryId,previewId){
        window.open("/vst_admin/prod/baseProduct/preview.do?categoryId="+categoryId+"&previewId="+previewId);
	}
	
//设置为有效或无效
	$("a.cancelProd").bind("click",function(){
		var entity = $(this);
		var cancelFlag = entity.attr("data");
		var productId = entity.attr("productId");
		var productName = entity.attr("productName");
		 msg = cancelFlag === "N" ? "确认下线  ？" : "确认上线  ？";
	 $.confirm(msg, function () {
		$.ajax({
			url : "/vst_admin/prod/customized/updateCancelFlag.do",
			type : "post",
			dataType:"JSON",
			data : {"cancelFlag":cancelFlag,"productId":productId,"productName":productName},
			success : function(result) {
			if (result.code == "success") {
				$.alert(result.message,function(){
					$("#searchForm").submit();
				});
			}else {
				$.alert(result.message);
			}
			}
		});
		});
	});
});
	function confirmAndRefresh(result){
		if (result.code == "success") {
			pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
				$("#searchForm").submit();
			}});
		}else {
			pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
				$.alert(result.message);
			}});
		}
	};
	
		//公告
	$("a.showNotice").bind("click",function(){
		var productId = $(this).attr("data");
	new xDialog("/vst_admin/prod/productNotice/findProductNoticeList.do?productId="+productId+"&noticeType=PRODUCT_All",{},{title:"公告",width:1000,iframe:true,scrolling:"yes"});
	});
	
	
	vst_pet_util.superUserSuggest("#productManagerName","#productManagerId");
	vst_pet_util.destListSuggest("#destName","#destId", true);
	
	$("#audit_submit").live("click",function(){
		var msg;
		var source = $(".audit").attr("source");
		var productId = $("#auditNotPass").attr("data");
		var categoryId = $("#auditNotPass").attr("data1");
		var categoryName = $("#auditNotPass").attr("categoryName");
		var settingUrl = "/vst_admin/tour/goods/goods/showBaseSuppGoods.do?prodProductId="+productId+"&categoryId="+categoryId
		$.ajax({
					url : "/vst_admin/prod/product/getSensitiveFlag.do",
					type : "post",
					dataType:"JSON",
					data : {"productId":productId},
					async:false,
					success : function(result) {
						if (result.code == "success") {
							msg = "确定提交？";
						}else {
							msg = result.message+'确定提交?';
						}
					}
			});
			
		$.confirm(msg,function(){
			var isPass = $("input[name='isPass']:checked").val();
			var content = $.trim($("textarea[name='content']").val());
			if(isPass=="N"&&content==""){
				$.alert("必须填写审核不通过原因");
				return;
			}
			
			$.ajax({
				url : "/vst_admin/prod/product/updateAudtiType.do",
				type : "post",
				dataType:"JSON",
				data : {"productId":productId,"currentAuditStatus":currentAuditType,"isPass" : isPass,"content" : content,"source":source,"bizCategoryId":categoryId},
				success : function(result) {
				if (result.code == "success") {
					$.alert(result.message,function(){
						 auditDialog.close();
						$("#search_button").click();
					});
				}else if(result.settingFlag == true){
					var notice;
					var settingFlag = result.settingFlag;
					notice = '<font color="red">提示:未设置归属BU或归属地</font>,<a target="_blank"  href="'+settingUrl+'" >' +'<font color="blue">去设置!</font></a>'
					$("#auditNotPass").html(notice);
				}else {
						$.alert(result.message);
				}
				}
			});
		});
	});
	
	
	$("#audit_cancel").live("click",function(){
			auditDialog.close();
	});		
    
$(function(){

showFloat();


});

//预览显示悬浮层
function showFloat(){
	var temp = {};
	var leftpos;
    var toppos;
    var time = {};
    var timer = {};
    
	$('.oper').delegate('a.showProd', 'mouseenter', function(e){
		
		var self = $(this);
		var s = self.attr('data');
		
		time[s] =setTimeout(function(){
		
		var url = "/vst_admin/prod/product/findProductGoodsPreview.do?productId="+s;
		leftpos = e.pageX
		toppos = e.pageY
		clearTimeout(timer[s]);
	if(self.attr('isClicked') == undefined){
			var showflag=false;
			$.ajax({
				  type: "GET",
				  url:url,
				  dataType: "html",
				  async: false,
				  success: function(result){
					  
					  if(result ==""){
						  showflag=true;
						}
						temp[s] = result;
						$("#showProductTargetBox").html(result);
					  }
				});
			self.attr('isClicked',s);
			if(showflag){
				return;
			}
			
			
		}else{
			if(temp[s]!=""){
				$("#showProductTargetBox").html(temp[s]);
			}else{
				return;
			}
		}
		//对于悬浮层超出边界时，位置调整
		if($(document.body).height() - toppos <= $("#showProductTargetBox").height()+33){
			toppos =  toppos -  $("#showProductTargetBox").height()-40;
		
		}
		
		if($(document.body).width() - leftpos <= $("#showProductTargetBox").width()){
			leftpos =  leftpos -  $("#showProductTargetBox").width();
		
		}
		
		timer[s] = setTimeout(function(){
			$('#showProductTargetBox').css("position", "absolute"); 
			$('#showProductTargetBox').css("left",leftpos);
        	$('#showProductTargetBox').css("top", toppos);
			$('#showProductTargetBox').css('display','block');
			$('#showProductTargetBox').attr('data',s);
		},100);
		
		
		
		},1000);
		
	}).delegate('a.showProd', 'mouseleave', function(){
		var self = $(this);
		var s = self.attr('data');
		clearTimeout(time[s]);
		clearTimeout(timer[s]);
		timer[s] = setTimeout(function(){
			$('#showProductTargetBox').css('display','none');
		},100);
	});
	
	$(document.body).delegate('#showProductTargetBox', 'mouseenter', function(){
		clearTimeout(timer[$(this).attr('data')]);
	}).delegate('#showProductTargetBox', 'mouseleave', function(){
		$(this).css('display','none');
	});


}


</script>


