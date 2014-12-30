SELECT author_id, entry_title, entry_content FROM entries WHERE primary_id in(SELECT max(primary_id) FROM entries group by entry_id);
