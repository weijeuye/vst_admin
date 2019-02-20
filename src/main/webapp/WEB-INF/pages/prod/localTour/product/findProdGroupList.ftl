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
            <li><a href="#">产品维护</a> &gt;</li>
            <li class="active">产品关联</li>
        </ul>
</div>
<div class="iframe_content">
	<div class="tiptext tip-warning cc5"><span class="tip-icon tip-icon-warning"></span>友情提示：
    <p class="pl15">注：每个产品只能关联一次,除发起组产品</p>
    <p class="pl15"> 注，前台展现行程标签根据行程天数,优先级进行显示</p>   
    <p class="pl15"> 注，此功能不支持多行程或者多出发地产品 </p> 
    </div>
    
    <div class="operate" style="margin-top:10px;margin-bottom:10px"><a class="btn btn_cc1" id="select">产品关联</a></div>
<!-- 主要内容显示区域\\ -->
    <#if prodGroupList?? &&  prodGroupList?size &gt; 0>
    <div class="p_box box_info">
    <table class="p_table table_center">
                <thead>
                    <tr>
                	<th width="80px">产品品类</th>
                    <th>产品ID</th>
                    <th>产品名称</th>
                    <th>行程天数</th>
                    <th>交通</th>
                    <th>状态</th>
                    <th>是否可售</th>
                    <th>排序</th>
                    <th>操作</th>
                    </tr>
                </thead>
                <tbody>
					<#list prodGroupList as prodGroup> 
					<tr>
					<td>${prodGroup.prodProduct.bizCategory.categoryName!''}</td>
					<td>${prodGroup.prodProduct.productId!''} </td>
					<td>${prodGroup.prodProduct.productName!''}</td>
					<td>${prodGroup.routeNum!''}天${prodGroup.stayNum!''}晚</td>
					<td>
					     <#if prodGroup.toTraffic!=null>
					     去程：${prodGroup.toTraffic!''}
					     </#if>
					     <#if prodGroup.backTraffic!=null>
					     返程：${prodGroup.backTraffic!''}
					     </#if>
					    <#if prodGroup.toTraffic==null&&prodGroup.backTraffic==null>
					     无
					     </#if>
					</td>
					<td>
						<#if prodGroup.prodProduct.cancelFlag == "Y"> 
						<span style="color:green" class="cancelProd">有效</span>
						<#else>
						<span style="color:red" class="cancelProd">无效</span>
						</#if>
					</td>
					<td><#if prodGroup.prodProduct.saleFlag =="Y">是<#else>否</#if></td>
					<td>
						<select name="seq" id="seq" data="${prodGroup.productId}" data1="${prodGroup.groupId}">
							<#list 1..9 as seq>
								<option value='${seq}' <#if prodGroup.seq == seq>selected</#if>>${seq}</option>
							</#list>
			        	</select>
					</td>
					<td class="oper">
					<a href="javascript:void(0);" class="editProp" 
						data="${prodGroup.prodProduct.productId}" data1="${prodGroup.groupId}">取消关联</a>
                    </td>
					</tr>
					</#list>
                </tbody>
            </table>
        
	</div><!-- div p_box -->
	<#else>
		<div class="no_data mt20"><i class="icon-warn32"></i>暂无相关关联产品！</div>
    </#if>
<!-- //主要内容显示区域 -->
<div class="fl operate">
	<a href="javascript:void(0);"  class="showLogDialog btn btn_cc1" param='objectId=${prodProductId}&objectType=PROD_GROUP&sysName=VST'>操作日志</a>
</div>
</div>

<#include "/base/foot.ftl"/>
</body>
</html>
<script>
	var productSelectDialog;
	var goodsSaleUpdateDialog;
	//打开关联产品列表
	$("#select").click(function(){
		var isProductSelect ='${isProductSelect}';
		if(isProductSelect !='true'){
			alert('${errorMsg}');
			return;
		}
		productSelectDialog = new xDialog("/vst_admin/localTour/prod/product/showSelectReProductList.do",{prodProductId:'${prodProductId}',categoryId:'${categoryId}'},{title:"选择关联产品",width:"1150",height:"350"});
	});
	
	//取消关联
	$(".editProp").click(function(){
		var productId = $(this).attr("data");
		var groupId = $(this).attr("data1");
		$.confirm("确定取消关联吗?",function(){
			$.ajax({
				url : '/vst_admin/selfTour/prodGroup/deleteProdGroupByRelate.do',
				data : {productId:productId,groupId:groupId,prodProductId:'${prodProductId}'},
				success : function(rs){
					if(rs.code=='success'){
						$.alert(rs.message, function(){
							window.location.reload();
						});
					}else {
			   		  	$.alert(rs.message);
			   		}
				}
			})
		});
	});
	
	//优先级设置
	$("select[name=seq]").on("change", function(){
		var productId =$(this).attr("data");
		var groupId =$(this).attr("data1");
		var seq =$(this).val();
		$.confirm("确定需要设置吗?",function(){
			$.ajax({
				url : '/vst_admin/selfTour/prodGroup/setSeqRetu.do',
				data:{prodProductId:'${prodProductId}', productId:productId, groupId:groupId, seq:seq},
				type : 'POST',
				success : function(rs){
					if(rs.code=='success'){
						$.alert(rs.message, function(){});
					}else {
			   		  	$.alert(rs.message);
			   		}
					
				}
			});
		});
	});
	
	function getMaxSize(){
		return '${maxSize}';
	}
    isView();
</script>


