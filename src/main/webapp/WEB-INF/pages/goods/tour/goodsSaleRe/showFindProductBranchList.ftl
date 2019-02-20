<#--页眉-->
<#import "/base/spring.ftl" as spring/>
<#import "/base/pagination.ftl" as pagination>
<#--页面导航-->
<div class="p_box box_info">
	<form method="post"  id="searchForm">
		<input type="hidden" name="oldProductId" value="${oldProductId!''}">
        <table class="s_table">
            <tbody>
                <tr>
                	<td class="s_label">品类：</td>
                    <td class="w18"><select name="categoryId">
                    	<option value="11">景点门票</option>
                    	<option value="12">其它票</option>
                        <option value="13">组合套餐票</option>
                    	<option value="4">签证</option>
                    	<#if isLocalCategory><option value="28">WIFI电话卡</option>
                    	<option value="41">交通接驳</option>
                    	<option value="31">演出票</option></#if>
                    	<#if addLocal><option value="16">当地游</option></#if>
                    </select></td>
                    <td class="s_label">产品名称：</td>
                    <td class="w18"><input type="text" name="productName" value="${productName!''}"></td>
                    <td class="s_label">产品ID：</td>
                    <td class="w18"><input type="text" name="productId" value="${productId!''}" number="true" ></td>
                    <td class=" operate mt10">
                   	<a class="btn btn_cc1" id="search_button">查询</a> 
                    </td>
                </tr>
                <tr>
                	<td class="s_label">规格名称：</td>
                	<td class="w18"><input type="text" name="branchName" value="${branchName!''}"></td>
                	<td class="s_label">规格ID：</td>
                    <td class="w18"><input type="text" name="productBranchId" number="true" value="${productBranchId!''}" /></td>
                </tr>
                
            </tbody>
        </table>	
		</form>
</div>
<form id="dataForm">
<input type="hidden" name="mainProductId" id="mainProductId">
<div class="p_box" id="logResultList">
            <table class="p_table table_center product">
                <thead> 
                    <tr class="noborder">
                        <th class="w10">产品类型</th>
                        <th class="w10 text_left">产品ID</th>
                        <th class="text_left">产品名称</th>
                        <th class="w10 text_left">规格ID</th>
                        <th class="text_left">规格</th>
						<th class="text_left">商品</th>
                    </tr>
                </thead>
                <tbody>
                    <#if pageParam?? && pageParam.items?? && pageParam.items?size &gt;  0>
                    <#list pageParam.items  as prod>
                    <tr>
                        <td class="w10"></td>
                        <td class="w10 text_left">${prod.productId}</td>
                        <td class="text_left">${prod.productName}</td>
                        <td class="w10"></td>
                        <td class="w10"></td>
						<td class="w10"></td>
                    </tr>
                    </#list>
                    <#else>
                    <tr class="table_nav"><td colspan="6"><div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div></td>	</tr>
                    </#if>
                </tbody>
            </table>
            <#if pageParam?? && pageParam.items?? && pageParam.items?size &gt;  0>
            <div class="pages darkstyle">	
            	<@pagination.paging pageParam true "#logResultList"/>
			 </div>
		 </#if>
  </div>
   </form>
  <div class="operate">
  	<a class="btn btn_cc1" id="save_addition">添加到附加</a> 
  </div>
  <script>
	  isView();
  		$("#search_button").click(function(){
  			$.ajax({
  				url : '/vst_admin/tour/goods/goods/suppGoodsSaleProductList.do',
  				type : 'POST',
  				data : $("#searchForm").serialize(),
  				success : function(res){
  					$("#logResultList").html(res);
  					if(prodBranchSelectDialog) {
  						prodBranchSelectDialog.resizeWH();
  					}
  				}
  			});
  		});
  		
  		//设置week选择,全选
		$("input[type=checkbox][name=All]").live("click",function(){
			if($(this).attr("checked")=="checked"){
				$("input[type=checkbox][name=productBranchIds]").attr("checked","checked");
			}else {
				$("input[type=checkbox][name=productBranchIds]").removeAttr("checked");
			}
		})
		
		
		 //设置week选择,单个元素选择
		$("input[type=checkbox][name=productBranchIds]").live("click",function(){
			if($("input[type=checkbox][name=productBranchIds]").size()==$("input[type=checkbox][name=productBranchIds]:checked").size()){
				$("input[type=checkbox][name=All]").attr("checked","checked");
			}else {
				$("input[type=checkbox][name=All]").removeAttr("checked");
			}
		});
		
		//保存添加到附加
		$("#save_addition").click(function(){
			if($("input[type=checkbox][name=productBranchIds]:checked").size()==0){
				$.alert("请选择规格");
				return;
			}else {
				var suppGoodsIds = "";
                $('input[name="productBranchIds"]:checked').each(function(){
					var goodsIds = "";
					$("input[name='pb_"+$(this).val()+"']:checked").each(function(){
						goodsIds += $(this).val() + ",";
					});
					suppGoodsIds += goodsIds.substring(0,goodsIds.length - 1)+";";
                });
                suppGoodsIds = suppGoodsIds.substring(0,suppGoodsIds.length - 1);
				$("#suppGoodsIds").val(suppGoodsIds);
				//保存
				$("#mainProductId").val($("#mainProductId1").val());
				$.ajax({
  				url : '/vst_admin/tour/goods/goods/openGoodsSaleRe.do',
  				type : 'POST',
  				async : false,
  				data : $("#dataForm").serialize(),
  				success : function(message){
  					prodBranchSelectDialog.close();
  					goodsSaleUpdateDialog = pandora.dialog({
					wrapClass: "dialog-big",
					width: 1000,
					height: 600,
					title : "设置规则",
					content : message,
					beforeunload:   function () {
					 	var that = this;
			            $.confirm("确定取消打包该产品吗？",function () {
						     delete that.config.beforeunload;
                    			that.close();
						    });
						    return false;
			        }
					});
				
  				}
  			});
			}
		});
  </script>