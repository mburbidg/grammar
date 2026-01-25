# Progress
I am currently working to enable graphExpressionPrimary. The most difficult part is the objectExpressionPrimary alternative. This gets down into the change made by Microsoft to _valueExpressionPrimary_, _nonParenthesizedValueExpression_ and _nonParenthesizedValueExpressionSpecialCase_. I'm still working to figure this out.

# Questions
1. Why are referenceValueExpression being moved from valueExpression to valueExpressionPrimary? They are currently commented out, but it looks like MSFT intends to do so. They are not ambiguous or mutually left recursive in valueExpression, and there are rules that reference valueExpressionPrimary, which would make those more permissive than needed.
2. Why was bindingVariableReference removed from valueExpressionPrimary?

# Progress

Working on sessionSetParameterClause