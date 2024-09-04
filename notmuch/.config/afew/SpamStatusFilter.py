from afew.FilterRegistry import register_filter
from afew.filters.HeaderMatchingFilter import HeaderMatchingFilter


@register_filter
class SpamStatusFilter(HeaderMatchingFilter):
    message = "Tagging spam messages"
    header = "X-Spam-Status"
    pattern = "Yes"

    def __init__(self, database, tags="+spam", spam_tag=None, **kwargs):
        if spam_tag is not None:
            # this is for backward-compatibility
            tags = "+" + spam_tag
        kwargs["tags"] = [tags]
        super().__init__(database, **kwargs)
