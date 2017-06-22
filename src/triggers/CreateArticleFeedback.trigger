trigger CreateArticleFeedback on FeedItem (after insert) {
	for (FeedItem f : trigger.new) {
		String parentId = f.parentId; 
		if (parentID.startsWith('kA') && f.type == 'TextPost') { 
		
			String q = 'select KnowledgeArticleId, articleNumber, title from KnowledgeArticleVersion where PublishStatus = \'online\' and Language = \'en_US\''; 
			
			q += 'and KnowledgeArticleId = \''+ parentId + '\'limit 1'; 
			
			KnowledgeArticleVersion kav = (KnowledgeArticleVersion) Database.query(q); 
            String feedcomment = f.Body;
			Article_Feedback__c afd = new Article_Feedback__c ( 
				Article_ID__c = parentId, 
				Article_Number__c = kav.articleNumber, 
				Article_Title__c = kav.title, 
				Article_Link__c = 'https://login.salesforce.com/'+ kav.KnowledgeArticleId+ '?popup=true', 
				Comments__c = feedcomment.substring(3, feedcomment.length()-4)); 
				
			insert afd; 
		} 
	}
}