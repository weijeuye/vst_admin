<#--页眉-->
<#import "/base/spring.ftl" as spring/>
<#import "/base/pagination.ftl" as pagination>
<#--页面导航-->
    <#if pageParam??>
    <#if pageParam.items?? &&  pageParam.items?size &gt; 0>
	<div class="p_box box_info" id="logResultList">
		<table class="p_table table_center" >
            <thead>
            	<tr>
                    <th>产品品类</th>
                    <th>产品ID</th>
                    <th>产品名称</th>
                    <th>行程天数</th>
                    <th>费用包含</th>
                    <th>目的地</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody class="candidateProductList">
        		<#list pageParam.items  as item>
	                <tr>
	                    <td width="50px">${item.categoryName}</td>
	                    <td width="50px">${item.productId}</td>
	                    <td width="150px">${item.productName}</td>
	                    <td width="60px">${item.lineRoute}</td>
	                    <td width="100px">${item.feeIncluded}</td>
	                    <td width="100px">${item.destinationInfo}</td>
	                    <td width="60px"><a href='javascript:void(0);' onclick='addAssociationRecommend(event,${item.productId});' >推荐产品</a></td>
	                </tr>
                </#list>
            </tbody>
        </table>
        <#if pageParam?? && pageParam.items?? && pageParam.items?size &gt;  0>
        	<@pagination.paging pageParam true "#logResultList"/>
	 	</#if>
	</div>
	<#else>
		<div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div>
    </#if>
    </#if>