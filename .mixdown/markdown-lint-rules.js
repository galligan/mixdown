module.exports = {
  "mixdown-toc-required": {
    names: ["mixdown-toc-required"],
    description: "Table of Contents must be present after H1",
    tags: ["mixdown"],
    function: (params, onError) => {
      const { tokens } = params;
      const h1Index = tokens.findIndex(t => t.type === 'heading_open' && t.tag === 'h1');
      
      if (h1Index !== -1) {
        const tocFound = tokens.some((t, i) => 
          i > h1Index && 
          t.type === 'heading_open' && 
          t.tag === 'h2' && 
          t.line && 
          t.line.includes('Table of Contents')
        );
        
        if (!tocFound) {
          onError({
            lineNumber: tokens[h1Index].lineNumber + 1,
            detail: "A '## Table of Contents' heading must follow the H1 title",
            context: tokens[h1Index].line
          });
        }
      }
    }
  }
}; 